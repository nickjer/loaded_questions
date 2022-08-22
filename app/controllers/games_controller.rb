# frozen_string_literal: true

class GamesController < ApplicationController
  # GET /games/:slug
  def show
    game = Game.includes(:players).find_by!(slug: params[:slug])
    current_player = game.players.find_by(user: @user)

    if current_player.blank?
      redirect_to(new_game_player_path(game))
    else
      @game = GamePresenter.new(game:, current_player:)
    end
  end
end
