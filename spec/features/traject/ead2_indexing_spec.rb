# frozen_string_literal: true

##### COPIED from ArcLight core spec. See:
##### https://github.com/projectblacklight/arclight/blob/master/spec/features/traject/ead2_indexing_spec.rb

require 'spec_helper'

RSpec.describe 'EAD 2 traject indexing', type: :feature do
  subject(:result) do
    indexer.map_record(record)
  end

  let(:indexer) do
    Traject::Indexer::NokogiriIndexer.new.tap do |i|
      i.load_config_file(Rails.root.join('lib', 'ngao-arclight', 'traject', 'ead2_config.rb'))
    end
  end

  let(:fixture_path) do
    Rails.root.join('spec', 'fixtures', 'ead', 'lilly', 'VAD6017.xml')
  end

  let(:fixture_file) do
    File.read(fixture_path)
  end

  let(:nokogiri_reader) do
    Arclight::Traject::NokogiriNamespacelessReader.new(fixture_file.to_s, indexer.settings)
  end

  let(:records) do
    nokogiri_reader.to_a
  end

  let(:record) do
    records.first
  end

  before do
    ENV['REPOSITORY_ID'] = nil
  end

  after do # ensure we reset these otherwise other tests will fail
    ENV['REPOSITORY_ID'] = nil
  end

  describe 'NGAO basic indexing customizations' do
    before do
      ENV['REPOSITORY_ID'] = 'lilly'
    end

    it 'campus unit' do
      expect(result['campus_unit_ssm']).to eq ['US-InU']
    end

    it 'does not index child level components with level = collection' do
      expect(result['component_level_isim']).to be nil
    end
  end
end
