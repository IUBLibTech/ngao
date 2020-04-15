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
  end

  it 'can extract a zip file' do
    zip_file = Rails.root.join('spec', 'fixtures', 'html', 'test.zip')
    unzipped_file = Rails.root.join('data', 'test', 'VAC0754.xml')
    EadProcessor.extract_and_index(zip_file, 'test')
    expect(unzipped_file).to exist
  end

  it 'gets the list of repositories' do
    client = "#{Rails.root}/spec/fixtures/html/test.html"
    repositories = EadProcessor.get_repository_names({ url: client })
    expect(repositories).to include 'Wylie House Museum'
  end

  # TODO: test for process_files method
  # TODO: test for index_file method

  it 'checks to see if it should process files' do
    args = { url: "#{Rails.root}/spec/fixtures/html/test.html", files: ['Test file'] }
    expect(EadProcessor.should_process_file(args, 'Test file')).to be true
    expect(EadProcessor.should_process_file(args, 'Not a test file')).to be false
  end
end
