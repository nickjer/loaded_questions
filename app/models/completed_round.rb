# frozen_string_literal: true

class CompletedRound < Form
  validates :round, presence: true
  validates :status, inclusion: { in: %w[matching] }

  # @return [Round]
  attr_accessor :round

  # @return [Game]
  delegate :game, to: :round

  # @return [Boolean]
  def save
    return false unless valid?

    Round.transaction do
      round.status = :completed
      round.save!
    end

    true
  rescue StandardError
    false
  end

  # @return [String]
  delegate :status, to: :round, private: true
end
