# frozen_string_literal: true

class MatchingRound < Form
  validates :round, presence: true
  validates :status, inclusion: { in: %w[polling] }

  # @return [Round]
  attr_accessor :round

  # @return [Game]
  delegate :game, to: :round

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
