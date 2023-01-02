# frozen_string_literal: true

class MatchRound
  # @param round [Round]
  def initialize(round:)
    @round = round
  end

  # @return [Boolean]
  def call
    return false unless round.polling?

    Round.transaction do
      round.matching!

      answers.zip(answers.shuffle).each do |answer, random_answer|
        answer.update!(guessed_participant: random_answer.participant)
      end
    end

    true
  end

  private

  # @return [Round]
  attr_reader :round

  # @!method answers
  #   @return [Array<Answer>]
  delegate :answers, to: :round
end
