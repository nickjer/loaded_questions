# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :player
  belongs_to :round

  has_one :game, through: :player

  validates :player,
    uniqueness: {
      scope: :round,
      message: "Answer already exists for this player"
    }
end
