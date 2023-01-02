# frozen_string_literal: true

class TurnForm < ApplicationForm
  # @return [Round]
  attr_reader :round

  # @return [Round]
  attr_reader :previous_round

  # @return [Array<Player>]
  attr_reader :participating_players

  # Validations
  validates :previous_round_status, inclusion: { in: %w[completed] }
  validate :round_is_valid
  validate :not_previous_guesser

  # @param guesser [Player]
  # @param params [#to_h]
  def initialize(guesser:, **params)
    game = guesser.game
    @previous_round = game.current_round

    @participating_players = game.active_players_since(num_rounds: 3)
    @round = Round.new(
      game: guesser.game,
      guesser:,
      participants:
        participating_players.map { |player| Participant.new(player:) },
      question: Round.seeded_question,
      hide_answers: previous_round.hide_answers,
      order: previous_round.order + 1
    )
    super(params)
  end

  # @!method guesser
  #   @return [Player]
  delegate :guesser, to: :round

  # @!method game
  #   @return [Game]
  delegate :game, to: :round

  # @!method round_attributes=(new_attributes)
  #   @param new_attributes [#each_pair]
  #   @return [void]
  delegate :attributes=, to: :round, prefix: :round

  # @return [Boolean]
  def save
    return false unless valid?

    round.save &&
      inactive_players.all? do |inactive_player|
        inactive_player.update(deleted_at: Time.current)
      end
  end

  private

  # @return [String]
  def previous_round_status
    previous_round.status
  end

  # @return [Array]
  def inactive_players
    game.active_players.difference(participating_players)
  end

  # @return [void]
  def round_is_valid
    return if round.valid?

    errors.add(:round, "is invalid")
  end

  # @return [void]
  def not_previous_guesser
    return if previous_round.guesser != round.guesser

    errors.add(:base, "Was the guesser in previous round")
  end
end
