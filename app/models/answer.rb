# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :player
  belongs_to :round
  belongs_to :guessed_player, class_name: "Player", optional: true

  has_one :game, through: :player

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
end
