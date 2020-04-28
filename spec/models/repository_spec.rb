# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Repository, type: :model do
  subject { described_class.new }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'is valid with valid attributes' do
    subject.repository_id = 'mix'
    subject.name = 'Mix of Collections'
    subject.last_updated_at = DateTime.now
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:user) }
    it { should have_many(:eads) }
  end
end
