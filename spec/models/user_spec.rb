# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  subject { described_class.new }

  it 'is not valid without valid attributes' do
    expect(subject).not_to be_valid
  end

  it 'is valid with valid attributes' do
    subject.email = 'test@example.com'
    subject.password = 'password'
    expect(subject).to be_valid
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:repositories) }
  end

  it 'should be assigned default role' do
    expect(subject.role).to eq 'manager'
  end

  it 'to_s method' do
    expect(subject.to_s).to eq subject.email
  end
end
