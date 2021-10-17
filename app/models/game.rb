# frozen_string_literal: true

class Game < ApplicationRecord
  enum status: { starting: 0, completed: 1 }, _prefix: true

  has_many :players, dependent: :destroy
  has_many :rounds, through: :players
end
