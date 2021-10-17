# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :rounds, dependent: :destroy

  validates :name, uniqueness: { scope: :game, case_sensitive: false }
  validates :game,
    uniqueness: { scope: :user, message: "Player already exists for this game" }
end
