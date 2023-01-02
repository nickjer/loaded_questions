# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :participant
  belongs_to :guessed_participant, class_name: "Participant", optional: true

  validates :value, length: { in: 3..80 }
  validates :participant, uniqueness: true
  validates :guessed_participant, uniqueness: true, allow_nil: true
  validate :cannot_be_from_round_guesser
  validate :cannot_guess_the_round_guesser
  validate :must_be_in_same_round

  # @param value [String, nil]
  # @return [void]
  def value=(value)
    normalized_value = value.to_s.unicode_normalize(:nfkc).squish
    normalized_value = normalized_value.gsub(/\P{Print}|\p{Cf}/, "").presence
    super(normalized_value)
  end

  # @return [Boolean]
  def correct?
    participant == guessed_participant
  end

  # @return [Boolean]
  def round_completed?
    participant.round.completed?
  end

  private

  # @return [void]
  def cannot_be_from_round_guesser
    return unless participant.guesser?

    errors.add(:participant, "cannot answer this question as the round guesser")
  end

  # @return [void]
  def cannot_guess_the_round_guesser
    return if guessed_participant.blank? || !guessed_participant.guesser?

    errors.add(:guessed_participant, "cannot guess the round guesser")
  end

  # @return [void]
  def must_be_in_same_round
    return if guessed_participant.blank?
    return if participant.round == guessed_participant.round

    errors.add(:guessed_participant, "must be in same round as answer owner")
  end
end
