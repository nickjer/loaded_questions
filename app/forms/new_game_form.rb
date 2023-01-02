# frozen_string_literal: true

class NewGameForm < ApplicationForm
  # @return [Player]
  attr_reader :player

  # @return [Round]
  attr_reader :round

  # @return [Game]
  attr_reader :game

  # Validations
  validate :player_is_valid
  validate :round_is_valid

  # @param user [User]
  # @param params [#to_h]
  def initialize(user:, **params)
    @player = Player.new(user:)
    @round = Round.new(
      guesser: @player,
      participants: [Participant.new(player: @player)]
    )
    @game = Game.new(players: [@player], rounds: [@round])
    super(params)
  end

  # @!method player_attributes=(new_attributes)
  #   @param new_attributes [#each_pair]
  #   @return [void]
  delegate :attributes=, to: :player, prefix: :player

  # @!method round_attributes=(new_attributes)
  #   @param new_attributes [#each_pair]
  #   @return [void]
  delegate :attributes=, to: :round, prefix: :round

  # @return [Boolean]
  def save
    return false unless valid?

    game.save
  end

  private

  # @return [void]
  def player_is_valid
    return if player.valid?

    errors.add(:player, "is invalid")
  end

  # @return [void]
  def round_is_valid
    return if round.valid?

    errors.add(:round, "is invalid")
  end
end
