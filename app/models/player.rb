# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :rounds, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :name, uniqueness: { scope: :game, case_sensitive: false }
  validates :game,
    uniqueness: { scope: :user, message: "Player already exists for this game" }

  scope :active, -> { joins(:rounds).merge(Round.current) }

  # @param value [String, nil]
  # @return [void]
  def name=(value)
    super(value&.strip)
  end

  # @return [Answer, nil]
  def current_answer
    @current_answer ||=
      game.current_answers.find do |current_answer|
        id == current_answer.player_id
      end
  end

  # @return [Answer, nil]
  def guessed_answer
    @guessed_answer ||=
      game.current_answers.find do |current_answer|
        id == current_answer.guessed_player_id
      end
  end
end
