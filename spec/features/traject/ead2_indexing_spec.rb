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

    it 'indexes extents contained within a single physdesc as one string' do
      expect(result['extent_ssm']).to eq ['184 items (1 box)', '8.15 cubic feet (One full-size records case, one letter-size documents case, twenty-six shelved books, and oversize material in flat storage.)']
    end

    it 'indexes the text in physdesc' do
      expect(result['physdesc_ssm']).to eq ['text for physical description']
    end

    it 'indexes all of the notes fields' do
      expect(result['odd_ssm'].last).to match(/One burnt field notebook with locality coordinates is separated for special care/)
      expect(result['materialspec_ssm'].last).to match(/Materials specific details/)
      expect(result['originalsloc_ssm'].last).to match(/Existence and location of originals/)
    end

    it 'collection acqinfo does not show on child elements' do
      expect(result['acqinfo_ssim']).to eq ['Purchase:  1982']
      component = result['components'].find { |c| c['id'] == ['InU-Li-VAD6017aspace_VAD6017-00001'] }
      expect(component['acqinfo_ssim']).to eq ['Child acqinfo']
    end
  end
end
