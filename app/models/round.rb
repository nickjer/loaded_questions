# frozen_string_literal: true

class Round < ApplicationRecord
  enum status: {
    active: 0,
    completed: 1
  }, _prefix: true

  belongs_to :game
end
