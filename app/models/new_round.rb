# frozen_string_literal: true

class NewRound < Form
  validates :previous_round, presence: true
  validates :player, presence: true
  validate :player_in_game

  # @return [Round]
  attr_accessor :previous_round

  # @return [Player]
  attr_accessor :player

  # @return [Boolean]
  def save
    return false unless valid?

    round.assign_attributes(
      question: "How are you doing?",
      previous: previous_round,
      player: player
    )

    round.save
  end

  private

  def player_in_game
    return if previous_round.game.players.exists?(player.id)

    errors.add(:player, message: "does not exist in this game")
  end

  # @return [Round]
  def round
    @round ||= Round.new
  end
end
