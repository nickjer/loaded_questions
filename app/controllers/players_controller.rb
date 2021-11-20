# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /games/:game_id/players/new
  def new
    @player = game.players.where(user: @user).build
  end

  # POST /games/:game_id/players
  def create
    @player = game.players.where(user: @user).build(player_params)

    if @player.save
      game.players.each do |player|
        Turbo::StreamsChannel.broadcast_append_later_to(
          player,
          target: "players",
          partial: "players/player",
          locals: { player: @player, active_player: game.active_player }
        )
      end
      redirect_to game
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @return [Game]
  def game
    @game ||= Game.find(params[:game_id])
  end

  # @return [ActionController::Parameters]
  def player_params
    params.require(:player).permit(:name)
  end
end
