# frozen_string_literal: true

class NewRound
  include ActiveModel::Model

  validates :previous_round, presence: true
  validates :player, presence: true

  # @return [Round]
  attr_accessor :previous_round

  # @return [Player]
  attr_accessor :player

  # @return [Game]
  delegate :game, to: :previous_round

  # @return [Round]
  def round
    # Do not use #build_* because it will delete original association
    @round ||= Round.new(
      question: "How are you doing?",
      previous: previous_round,
      player: player
    )
  end

  # @return [Boolean]
  def save
    return false unless valid?

    round.save
  end
end
