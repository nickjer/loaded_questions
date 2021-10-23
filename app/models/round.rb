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
end
