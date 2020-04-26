# frozen_string_literal: true
class Repository < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id', optional: true
end