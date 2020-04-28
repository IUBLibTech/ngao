# frozen_string_literal: true
class Ead < ApplicationRecord
  belongs_to :repository, foreign_key: 'repository_id', optional: true
end