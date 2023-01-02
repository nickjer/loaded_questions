# frozen_string_literal: true

class AnswerSwapper
  include FormModel

  validates :answer_id, presence: true
  validates :swap_answer_id, presence: true
  validates :round, presence: true

  validates :answer, presence: true
  validates :swap_answer, presence: true

  # @return [Round]
  attr_accessor :round

  # @return [String]
  attr_accessor :answer_id

  # @return [String]
  attr_accessor :swap_answer_id

  # @return [Answer, nil]
  def answer
    return if round.blank? || answer_id.blank?

    @answer ||= Answer.where(participant: Participant.where(round:))
      .find(answer_id)
  end

  # @return [Answer, nil]
  def swap_answer
    return if round.blank? || swap_answer_id.blank?

    @swap_answer ||= Answer.where(participant: Participant.where(round:))
      .find(swap_answer_id)
  end

  # @return [Boolean]
  def save
    return false unless valid?

    Answer.transaction do
      guessed_participant = answer.guessed_participant
      swap_guessed_participant = swap_answer.guessed_participant
      answer.update!(guessed_participant: nil)
      swap_answer.update!(guessed_participant:)
      answer.update!(guessed_participant: swap_guessed_participant)
    end

    true
  rescue StandardError
    false
  end
end
