# frozen_string_literal: true

class NewRound < Form
  validates :player, presence: true
  validates :previous_round, presence: true
  validates :previous_round_status, inclusion: { in: %w[completed] }

  # @return [Player, nil]
  attr_accessor :player

  # @return [Boolean]
  def save
    return false unless valid?

    Round.transaction do
      round = player.rounds.build(
        question: "How are you doing?",
        previous: previous_round
      )
      round.save!
    end

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
