# frozen_string_literal: true

class ActiveRound
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include LogValidations

  # @return [Game]
  attr_accessor :game

  # @return [User]
  attr_accessor :user

  validates :game, presence: true
  validates :user, presence: true
  validates :current_player, presence: true
  validates :round, presence: true
  validate :round_is_valid

  # @return [Player, nil]
  def current_player
    return if game.blank?

    @current_player ||= game.players.find_by(user: user)
  end

  # @return [Round, nil]
  def round
    return if current_player.blank?

    @round ||= current_player.rounds.build(question: question)
  end

  # @return [String]
  def question
    "How are you doing?"
  end

  # @return [Boolean]
  def save
    valid? && round.save
  end

  private

  def round_is_valid
    return if round.blank? || round.valid?

    round.errors.each do |error|
      errors.add(:"round.#{error.attribute}", error.message)
    end
  end
end
