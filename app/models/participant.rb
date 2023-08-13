# frozen_string_literal: true

class Participant < ApplicationRecord
  belongs_to :player
  belongs_to :round

  has_one :answer, -> { includes(:participant, :guessed_participant) },
    dependent: :destroy, inverse_of: :participant

  validates :player, uniqueness: { scope: :round }
  validate :player_in_game

  # @!method name
  #   @return [String]
  delegate :name, :sortable_name, to: :player

  # @return [Boolean]
  def guesser?
    player == round.guesser
  end

  private

  # @return [void]
  def player_in_game
    return if round.game == player.game

    errors.add(:player, "not in same game as round")
  end
end
