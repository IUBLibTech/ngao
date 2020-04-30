# frozen_string_literal: true

require 'spec_helper'
require 'pathname'

RSpec.describe EadProcessor do
  it 'gets the client without args' do
    client = EadProcessor.client
    expect(client).to eq 'https://aspacedev.dlib.indiana.edu/assets/ead_export/'
  end

  it 'gets the client with args' do
    client = EadProcessor.client({ url: "#{Rails.root}/spec/fixtures/html/" })
    expect(client).to eq "#{Rails.root}/spec/fixtures/html/"
  end

  after do
    FileUtils.rm_rf(Dir["#{Rails.root}/data/test"])
    FileUtils.rm_rf(Dir["#{Rails.root}/data/test2"])
  end

  it 'can extract a zip file' do
    zip_file = Rails.root.join('spec', 'fixtures', 'html', 'test.zip')
    unzipped_file = Rails.root.join('data', 'test', 'VAC0754.xml')
    EadProcessor.extract_and_index(zip_file, 'test')
    expect(unzipped_file).to exist
  end

  # skipping for now, cannot open zip file locally for testing to get the ead names
  xit 'gets the list of repositories' do
    client = "#{Rails.root}/spec/fixtures/html/test.html"
    repositories = EadProcessor.get_repository_names({ url: client })
    expect(repositories).to include(
      "test"=>{:name=>"Working Men's Institute of New Harmony, Indiana", :eads=>["VAA9110.xml", "VAA6610.xml", "VAA4026.xml"]}, 
      "test2"=>{:name=>"Wylie House Museum", :eads=>["VAD3254.xml", "VAC2939.xml", "VAC0754.xml", "VAC1801.xml", "VAC0944.xml"]}
    )
  end

  it 'gets the list of eads' do
    file = "#{Rails.root}/spec/fixtures/html/test.zip"
    eads = EadProcessor.get_ead_names(file, 'mix')
    expect(eads).to include('VAD3254.xml')
  end

  it 'checks to see if it should process files' do
    args = { url: "#{Rails.root}/spec/fixtures/html/test.html", files: ['Test file'] }
    expect(EadProcessor.should_process_file(args, 'Test file')).to be true
    expect(EadProcessor.should_process_file(args, 'Not a test file')).to be false
  end

  it 'adds the repository to the db' do
    repo_id = 'test'
    repo_name = "Working Men's Institute of New Harmony, Indiana"
    repo_last_updated_at = DateTime.parse('(last updated: 2020-04-24 06:01:53)') 
    new_repository = EadProcessor.add_repository_to_db(repo_id, repo_name, repo_last_updated_at)
    expect(new_repository.repository_id).to eq(repo_id)
    expect(new_repository.name).to eq(repo_name)
    expect(new_repository.last_updated_at).to eq(repo_last_updated_at)
  end

  context 'eads' do
    let(:repository) { Repository.new }

    it 'adds the ead to the db' do
      filename = 'VAD3254.xml'
      repository.repository_id = 'mix'
      ead = EadProcessor.add_ead_to_db(filename, repository.repository_id)
      expect(ead.filename).to eq(filename)
    end

    it 'adds the ead last_updated_at' do
      repository.repository_id = 'mix'
      filename = 'VAD3254.xml'
      ead = EadProcessor.add_ead_to_db(filename, repository.repository_id)
      last_updated_at = Time.now
      updated_ead = EadProcessor.add_last_updated(filename, last_updated_at)
      expect(updated_ead).to be true
    end

    it 'adds the ead last_indexed_at' do
      repository.repository_id = 'mix'
      filename = 'VAD3254.xml'
      ead = EadProcessor.add_ead_to_db(filename, repository.repository_id)
      last_indexed_at = Time.now
      updated_ead = EadProcessor.add_last_updated(filename, last_indexed_at)
      expect(updated_ead).to be true
    end
  end
end
