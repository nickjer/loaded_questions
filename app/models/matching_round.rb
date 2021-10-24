# frozen_string_literal: true

class MatchingRound
  include ActiveModel::Model

  validates :round, presence: true
  validates :status, inclusion: { in: %w[polling] }

  # @return [Round]
  attr_accessor :round

  # @return [Game]
  delegate :game, to: :round

  # @return [Boolean]
  def save
    return false unless valid?

    round.status = :matching

    round.save
  end

  # @return [String]
  delegate :status, to: :round, private: true
end
