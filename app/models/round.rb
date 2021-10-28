# frozen_string_literal: true

class Round < ApplicationRecord
  enum status: { polling: 0, matching: 1, completed: 2 }

  belongs_to :player
  belongs_to :previous, class_name: "Round", optional: true

  has_many :answers, dependent: :destroy

  has_one :game, through: :player
  has_one :next, class_name: "Round", foreign_key: :previous_id,
    inverse_of: :previous, dependent: :destroy
  has_many :participating_players, through: :answers, source: :player

  scope :current,
    -> { left_outer_joins(:next).where(nexts_rounds: { id: nil }).distinct }

  validates :question, presence: true
  validates :previous, uniqueness: { allow_blank: true }
  validate :all_rounds_completed, on: :create
  validate :single_root_round, on: :create

  # @return [Game, nil]
  def game
    # This is a workaround for https://github.com/rails/rails/issues/33155
    super || player&.game
  end

  # @return [void]
  def question=(value)
    super(value&.strip)
  end

  private

  def all_rounds_completed
    return unless game.rounds.not_completed.exists?

    errors.add(:base, "Active round currently exists for this game")
  end

  def single_root_round
    return if previous.present? || !game.rounds.exists?

    errors.add(:base, "Game already has an initial round")
  end
end
