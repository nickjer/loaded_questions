# frozen_string_literal: true

class RedrawPlayersJob < ApplicationJob
  queue_as :default

  def perform(game)
    game.players.each do |player|
      PlayerChannel.broadcast_update_to(
        player,
        target: "players",
        collection: game.players,
        partial: "players/player",
        locals: { active_player: game.active_player, me: player }
      )
    end
  end
end
