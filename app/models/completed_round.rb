# frozen_string_literal: true

class CompletedRound < Form
  # @return [Round]
  attr_reader :round

  # @return [Game]
  delegate :game, to: :round

  # @return [Array<Player>]
  delegate :players, to: :game

  # Validations
  validates :round, presence: true
  validates :status, inclusion: { in: %w[matching] }

  # @param round [Round]
  def initialize(round)
    @round = round
  end

  # @return [Boolean]
  def save
    return false unless valid?

    Round.transaction do
      round.status = :completed
      round.save!
    end

    true
  rescue StandardError
    false
  end

  # @return [String]
  delegate :status, to: :round, private: true
end
