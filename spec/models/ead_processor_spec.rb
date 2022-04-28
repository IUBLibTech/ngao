# frozen_string_literal: true

require 'spec_helper'
require 'pathname'

RSpec.describe EadProcessor, clean: true do
  it 'gets the client without args' do
    client = EadProcessor.client
    expect(client).to eq 'http://localhost/assets/ead_export/'
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

  context 'eads and html for downloads' do
    after do
      FileUtils.rm_rf(Dir["#{Rails.root}/public/ead/VAD6017.xml"])
      FileUtils.rm_rf(Dir["#{Rails.root}/public/html/VAD6017.html"])
    end
    
    it 'can copy ead to public directory' do
      ead = Rails.root.join('spec', 'fixtures', 'ead', 'lilly', 'VAD6017.xml')
      public_ead = Rails.root.join('public', 'ead', 'VAD6017.xml')
      EadProcessor.save_ead_for_downloading(ead)
      expect(public_ead).to exist
    end
    
    it 'can transform an ead to html and place it in public directory' do
      html = Rails.root.join('public', 'html', 'VAD6017.html')
      ead = Rails.root.join('spec', 'fixtures', 'ead', 'lilly', 'VAD6017.xml')
      EadProcessor.convert_ead_to_html(ead)
      expect(html).to exist
    end
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
    let(:filename) { 'VAD3254.xml' }

    it 'adds the ead to the db' do
      repository.repository_id = 'mix'
      ead = EadProcessor.add_ead_to_db(filename, repository.repository_id)
      expect(ead.filename).to eq(filename)
    end

    it 'adds the ead last_updated_at' do
      repository.repository_id = 'mix'
      ead = EadProcessor.add_ead_to_db(filename, repository.repository_id)
      last_updated_at = Time.now
      updated_ead = EadProcessor.add_last_updated(filename, last_updated_at)
      expect(updated_ead).to be true
    end

    it 'adds the ead last_indexed_at' do
      repository.repository_id = 'mix'
      ead = EadProcessor.add_ead_to_db(filename, repository.repository_id)
      last_indexed_at = Time.now
      updated_ead = EadProcessor.add_last_updated(filename, last_indexed_at)
      expect(updated_ead).to be true
    end

    it 'removes a single ead' do
      repository.repository_id = 'mix'
      ead = EadProcessor.add_ead_to_db(filename, repository.repository_id)
      r = repository.save
      existing_repo = Repository.find(1)
      expect(Ead.count).to eq 1
      EadProcessor.remove_ead_from_db(filename)
      expect(Ead.count).to eq 0
    end
  end
end
