# frozen_string_literal: true

class CreateRound
  # @param player [Player]
  def initialize(player)
    @player = player
  end

  # @return [Boolean]
  def call
    question = "How are you doing?"

    player.rounds.create!(question: question)

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
