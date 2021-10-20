# frozen_string_literal: true

class Round < ApplicationRecord
  enum status: { active: 0, completed: 1 }, _prefix: true

  belongs_to :player
  has_one :game, through: :player
  has_many :answers, dependent: :destroy

  validates :question, presence: true
  validate :active_round_unique_per_game, on: :create

  private

  def active_round_unique_per_game
    return if !game.active_rounds.exists? || !status_active?

    errors.add(:base, :taken, message: "Active round has already been taken")
  end
end
