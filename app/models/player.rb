# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :rounds, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_one :active_round, -> { status_active.order(created_at: :asc) },
    class_name: "Round", inverse_of: :player, dependent: nil
  has_one :active_answer, ->(player) { where(player: player) },
    through: :game, source: :active_answers

  validates :name, uniqueness: { scope: :game, case_sensitive: false }
  validates :game,
    uniqueness: { scope: :user, message: "Player already exists for this game" }
end
