# frozen_string_literal: true

class AnswerSwapper < Form
  validates :answer_id, presence: true
  validates :answer_swap_id, presence: true
  validates :round, presence: true

  validates :answer, presence: true
  validates :answer_swap, presence: true

  # @return [String]
  attr_accessor :answer_id

  # @return [String]
  attr_accessor :answer_swap_id

  # @return [Round]
  attr_accessor :round

  # @return [Boolean]
  def save
    return false unless valid?

    Answer.transaction do
      guessed_player = answer.guessed_player
      answer.guessed_player = answer_swap.guessed_player
      answer_swap.guessed_player = guessed_player

      answer.save
      answer_swap.save
    end

    true
  rescue StandardError
    false
  end

  private

  # @return [Answer, nil]
  def answer
    return if round.blank?

    @answer ||= round.answers.find(answer_id)
  end

  # @return [Answer, nil]
  def answer_swap
    return if round.blank?

    @answer_swap ||= round.answers.find(answer_swap_id)
  end
end
