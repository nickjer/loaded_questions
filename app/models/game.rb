# frozen_string_literal: true

class Game < ApplicationRecord
  enum status: { playing: 0, completed: 1 }

  has_many :players, dependent: :destroy
  has_many :rounds, through: :players

  # @return [Round, nil]
  def current_round
    @current_round ||= rounds.current.first
  end

  # @return [Player, nil]
  def active_player
    @active_player ||= current_round&.player
  end

  # @return [Array<Answer>]
  def current_answers
    @current_answers ||= current_round&.answers.to_a
  end
end
