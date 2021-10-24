# frozen_string_literal: true

class NewRound
  include ActiveModel::Model

  validates :previous_round, presence: true
  validates :player, presence: true

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

  # @return [Round]
  def round
    @round ||= Round.new
  end
end
