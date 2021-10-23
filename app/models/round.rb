# frozen_string_literal: true

class Round < ApplicationRecord
  enum status: { active: 0, completed: 1 }, _prefix: true

  belongs_to :player
  belongs_to :previous, class_name: "Round", optional: true

  has_many :answers, dependent: :destroy

  has_one :game, through: :player
  has_one :next, class_name: "Round", foreign_key: :previous_id,
    inverse_of: :previous, dependent: :destroy

  scope :current,
    -> { left_outer_joins(:next).where(nexts_rounds: { id: nil }).distinct }

  validates :question, presence: true
  validates :previous, uniqueness: { allow_blank: true }
  validate :all_rounds_completed, on: :create
  validate :single_root_round, on: :create

  private

  def all_rounds_completed
    return unless player.game.rounds.status_active.exists?

    errors.add(:base, "Active round currently exists for this game")
  end

  def single_root_round
    return if previous.present? || !player.game.rounds.exists?

    errors.add(:base, "Game already has an initial round")
  end
end
