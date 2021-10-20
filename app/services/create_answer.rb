# frozen_string_literal: true

class CreateAnswer
  # @param player [Player]
  def initialize(player)
    @player = player
  end

  # @return [Boolean]
  def call(value:)
    player.answers.create!(value: value, round: game.active_round)

    true
  rescue StandardError
    false
  end

  private

  # @return [Player]
  attr_reader :player

  # @return [Game]
  def game
    player.game
  end
end
