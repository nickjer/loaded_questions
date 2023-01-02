# frozen_string_literal: true

class CompleteRound
  # @param round [Round]
  def initialize(round:)
    @round = round
  end

  # @return [Boolean]
  def call
    return false unless round.matching?

    round.completed!

    true
  end

  private

  # @return [Round]
  attr_reader :round
end
