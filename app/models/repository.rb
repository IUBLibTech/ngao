# frozen_string_literal: true
class Repository < ApplicationRecord
  has_and_belongs_to_many :user
  has_many :eads
end
