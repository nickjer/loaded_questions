# frozen_string_literal: true

class NewRound
  include FormModel

  # @return [Player]
  attr_reader :player

  # @return [String]
  attr_reader :question

  # @return [Boolean]
  attr_reader :hide_answers

  # Validations
  validates :player, presence: true
  validates :question, length: { in: 3..80 }
  validates :hide_answers, inclusion: [true, false]
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

    @hide_answers = ActiveModel::Type::Boolean.new.cast(params[:hide_answers])
    @hide_answers = previous_round.hide_answers if @hide_answers.nil?
  end

  # @return [Boolean]
  def save
    return false unless valid?

    round = player.rounds.build(
      question:,
      previous: previous_round,
      hide_answers:
    )

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
