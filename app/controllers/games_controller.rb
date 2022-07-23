# frozen_string_literal: true

class GamesController < ApplicationController
  # GET /games/1
  def show
    @game = Game.includes(:players).find(params[:id])
    @current_player = @game.players.find_by(user: @user)

    # Create player if user doesn't have one
    return redirect_to(new_game_player_path(@game)) if @current_player.blank?

    @active_player = @game.active_player
    @current_round = @game.current_round
    return unless @current_round.polling?

    @answer = @current_round.answers
      .find_or_initialize_by(player: @current_player)
  end
end
