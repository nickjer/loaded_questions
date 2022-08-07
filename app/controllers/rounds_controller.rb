# frozen_string_literal: true

class RoundsController < ApplicationController
  # GET /rounds/1
  def show
    @round = Round.find(params[:id])
    @current_player = Player.find_by!(
      user: @user, game: Game.where(players: Player.where(rounds: @round))
    )
  end
end
