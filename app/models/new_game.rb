# frozen_string_literal: true

class NewGame
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks
  include LogValidations

  validates :player_name, presence: true
  validates :user, presence: true

  # @return [String]
  attr_accessor :player_name

  # @return [User]
  attr_accessor :user

  # @!method persisted?
  #   @return [Boolean]
  delegate :persisted?, to: :game

  # @!method to_param
  #   @return [String, nil]
  delegate :to_param, to: :game

  # @return [Boolean]
  def save
    return false unless valid?

    player.assign_attributes(name: player_name, user: user)
    player.rounds << Round.new(question: question)

    game.players << player

    game.save && @persisted = true
  end

  private

  # @return [String]
  def question
    "How are you doing?"
  end

  # @return [Player]
  def player
    @player ||= Player.new
  end

  # @return [Game]
  def game
    @game ||= Game.new
  end
end
