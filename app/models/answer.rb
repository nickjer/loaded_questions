# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :player
  belongs_to :round
  belongs_to :guessed_player, class_name: "Player", optional: true

  has_one :game, through: :player

  validates :value, presence: true
  validates :player,
    uniqueness: {
      scope: :round,
      message: "Answer already exists for this player"
    }
  validates :guessed_player,
    uniqueness: {
      scope: :round,
      allow_blank: true,
      messages: "You already guessed this player on another answer"
    }

  scope :ordered_by_guessed_player,
    -> { includes(:guessed_player).order("players.name") }

  # @return [void]
  def value=(value)
    super(value&.strip)
  end

  # @return [Boolean]
  def readonly?
    round.completed?
  end

  # @return [Boolean]
  def correct?
    player_id == guessed_player_id
  end

  # @!method round_completed?
  #   @return [Boolean]
  delegate :completed?, to: :round, prefix: true
end
