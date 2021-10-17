# frozen_string_literal: true

class Game < ApplicationRecord
  enum status: { active: 0, completed: 1 }, _prefix: true

  has_many :players, dependent: :destroy
  has_many :rounds, through: :players
  has_many :active_rounds, -> { status_active.order(created_at: :asc) },
    through: :players, source: :rounds

  # @return [Boolean]
  def active_rounds?
    active_rounds.exists?
  end

  # @return [Round, nil]
  def active_round
    active_rounds.first
  end
end
