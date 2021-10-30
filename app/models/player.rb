# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_many :rounds, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_one :current_answer, ->(player) { where(player: player) },
    through: :game, source: :current_answers

  validates :name, uniqueness: { scope: :game, case_sensitive: false }
  validates :game,
    uniqueness: { scope: :user, message: "Player already exists for this game" }

  scope :active, -> { joins(:rounds).merge(Round.current) }

  # @return [void]
  def name=(value)
    super(value&.strip)
  end
end
