# frozen_string_literal: true

require 'spec_helper'
require 'ngao/year_range'

RSpec.describe Ngao::YearRange do
  subject(:range) { described_class.new }

  describe '#to_year_from_iso8601' do
    # IU has lots of collections with three digit dates
    it 'handles first millenium (no leading 0s)' do
      expect(range.to_year_from_iso8601('500')).to eq 500
    end
  end

  describe '#parse_range' do
    # Override Arclight default behavior to allow really large ranges
    it 'handles very large YYYY/YYYY' do
      expect { range.parse_range('1999/9999') }.not_to raise_error
    end

    it 'handles leading zeros' do
      expect(range.parse_range('0001/1995')).to eq ((1..1995).to_a)
    end

    it 'handles range is first millenium' do
      expect(range.parse_range('25/315')).to eq ((25..315).to_a)
    end
  end
end
