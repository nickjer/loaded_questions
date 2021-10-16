# frozen_string_literal: true

class Game < ApplicationRecord
  enum status: { starting: 0, completed: 1 }, _prefix: true

  has_many :rounds, dependent: :destroy
end
