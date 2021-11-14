# frozen_string_literal: true

class MatchingRound
  include FormModel

  # @return [Round]
  attr_reader :round

  # Validations
  validates :round, presence: true
  validates :status, inclusion: { in: %w[polling] }

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
      round.status = :matching
      randomized_players = round.participating_players.shuffle

      round.answers.zip(randomized_players).each do |answer, random_player|
        answer.update!(guessed_player: random_player)
      end

      round.save!
    end

    true
  rescue StandardError
    false
  end

  # @return [String]
  delegate :status, to: :round, private: true
end
