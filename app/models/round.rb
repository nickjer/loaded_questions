# frozen_string_literal: true

class Round < ApplicationRecord
  enum status: { polling: 0, matching: 1, completed: 2 }

  belongs_to :guesser, class_name: "Player"
  belongs_to :game

  has_many :participants, -> { includes(:player, :answer) },
    dependent: :destroy, inverse_of: :round

  validates :question, length: { in: 3..160 }
  validates :game, uniqueness: { scope: :order }
  validate :guesser_in_game
  validate :next_highest_order, on: :create
  validate :all_rounds_completed, on: :create

  class << self
    # @return [String]
    def seeded_question
      Rails.configuration.x.questions.sample.to_s
    end
  end

  # @return [String, nil]
  def question
    @question ||= self.class.seeded_question
  end

  # @return [Array<Answer>]
  def answers
    participants.map(&:answer).compact
  end

  # @return [Boolean]
  def show_answers?
    !hide_answers?
  end

  # @return [Boolean]
  def match?
    answers.size > 1
  end

  private

  # @return [void]
  def guesser_in_game
    return if game == guesser.game

    errors.add(:guesser, "does not exist in this game")
  end

  # @return [void]
  def next_highest_order
    highest_order = Round.where(game:).order(:order).last&.order
    return if highest_order.blank?
    return if (order - 1) == highest_order

    errors.add(:order, "must be the next highest integer")
  end

  # @return [void]
  def all_rounds_completed
    return unless game.rounds.not_completed.exists?

    errors.add(:base, "Active round currently exists for this game")
  end
end
