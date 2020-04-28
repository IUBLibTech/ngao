# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ead, type: :model do
  subject { described_class.new }

  it 'is not valid' do
    expect(subject).to be_valid
  end

  it 'is valid with valid attributes' do
    subject.filename = 'VAD6017.xml'
    subject.last_updated_at = Time.now - 1.hour
    subject.last_indexed_at = Time.now
    subject.repository_id = 1
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:repository).optional.with_foreign_key('repository_id') }
  end
end
