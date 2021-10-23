# frozen_string_literal: true

class Game < ApplicationRecord
  enum status: { active: 0, completed: 1 }, _prefix: true

  has_many :players, dependent: :destroy

  has_many :rounds, through: :players
  has_one :active_player, -> { active }, class_name: "Player",
    inverse_of: :game, dependent: nil
  has_one :current_round, -> { current }, through: :active_player,
    source: :rounds
  has_many :current_answers, through: :current_round, source: :answers
end
