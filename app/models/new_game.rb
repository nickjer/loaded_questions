# frozen_string_literal: true

class NewGame
  include ActiveModel::Model

  # @return [String]
  attr_accessor :player_name

  # @return [User]
  attr_accessor :user

  validates :player_name, presence: true
  validates :user, presence: true

  # @return [Game, nil]
  def create_game
    return unless valid?

    question = "How are you doing?"
    player = Player.new(name: player_name, user: user)
    player.rounds.build(question: question)

    Game.create!(players: [player])
  end
end
