# frozen_string_literal: true

class NewRound < Form
  # @return [Player]
  attr_reader :player

  # @return [String]
  attr_reader :question

  # Validations
  validates :player, presence: true
  validates :question, presence: true
  validates :previous_round, presence: true
  validates :previous_round_status, inclusion: { in: %w[completed] }

  # @!method game
  #   @return [Game]
  delegate :game, to: :player

  # @!method players
  #   @return [Array<Player>]
  delegate :players, to: :game

  # @param player [Player]
  # @param params [#to_h]
  def initialize(player:, params: nil)
    @player = player

    params = params.to_h.deep_symbolize_keys
    @question = params[:question].to_s.squish
  end

  # @return [Boolean]
  def save
    return false unless valid?

    round = player.rounds.build(question: question, previous: previous_round)

    round.save
  end

  private

  # @return [Round, nil]
  def previous_round
    game.current_round
  end

  # @return [String, nil]
  def previous_round_status
    previous_round&.status
  end
end
