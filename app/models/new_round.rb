# frozen_string_literal: true

class NewRound < Form
  validates :player, presence: true
  validates :question, presence: true
  validates :previous_round, presence: true
  validates :previous_round_status, inclusion: { in: %w[completed] }

  # @return [Player, nil]
  attr_accessor :player

  # @return [String, nil]
  attr_accessor :question

  # @return [Boolean]
  def save
    return false unless valid?

    player.rounds.create!(question: question, previous: previous_round)

    true
  rescue StandardError
    false
  end

  private

  # @return [Game, nil]
  def game
    player&.game
  end

  # @return [Round, nil]
  def previous_round
    game&.current_round
  end

  # @return [String, nil]
  def previous_round_status
    previous_round&.status
  end
end
