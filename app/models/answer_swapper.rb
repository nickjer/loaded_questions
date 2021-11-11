# frozen_string_literal: true

class AnswerSwapper < Form
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

    @answer ||= round.answers.find(answer_id)
  end

  # @return [Answer, nil]
  def swap_answer
    return if round.blank? || swap_answer_id.blank?

    @swap_answer ||= round.answers.find(swap_answer_id)
  end

  # @return [Boolean]
  def save
    return false unless valid?

    Answer.transaction do
      guessed_player = answer.guessed_player
      swap_guessed_player = swap_answer.guessed_player
      answer.update!(guessed_player: nil)
      swap_answer.update!(guessed_player: guessed_player)
      answer.update!(guessed_player: swap_guessed_player)
    end

    true
  rescue StandardError
    false
  end
end
