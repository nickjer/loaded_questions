# frozen_string_literal: true

class SwapAnswers
  # @param answer [Answer]
  # @param other_answer [Answer]
  def initialize(answer:, other_answer:)
    @answer = answer
    @other_answer = other_answer
  end

  # @return [Boolean]
  def call
    Answer.transaction do
      guessed_participant = answer.guessed_participant
      other_guessed_participant = other_answer.guessed_participant
      answer.update!(guessed_participant: nil)
      other_answer.update!(guessed_participant:)
      answer.update!(guessed_participant: other_guessed_participant)
    end

    true
  rescue StandardError => e
    Rails.logger.error(e.message)
    false
  end

  private

  # @return [Answer]
  attr_reader :answer

  # @return [Answer]
  attr_reader :other_answer
end
