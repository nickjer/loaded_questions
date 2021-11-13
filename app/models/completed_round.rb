# frozen_string_literal: true

class CompletedRound < Form
  # @return [Round]
  attr_reader :round

  # Validations
  validates :round, presence: true
  validates :status, inclusion: { in: %w[matching] }

  # @!method game
  #   @return [Game]
  delegate :game, to: :round

  # @!method players
  #   @return [Array<Player>]
  delegate :players, to: :game

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
