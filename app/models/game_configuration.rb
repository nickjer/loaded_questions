# frozen_string_literal: true

class GameConfiguration
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

    player = Player.new(name: player_name, user: user)
    Game.create!(players: [player])
  end
end
