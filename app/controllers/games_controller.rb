# frozen_string_literal: true

class GamesController < ApplicationController
  # GET /games/1
  def show
    @game = Game.includes(
      :active_player,
      players: :current_answer,
      current_round: [
        :participating_players,
        { ordered_answers: %i[player guessed_player] }
      ]
    ).find(params[:id])
    @current_player = @game.players.find_by(user: @user)

    # Create player if user doesn't have one
    return redirect_to(new_game_player_path(@game)) if @current_player.blank?

    @active_player = @game.active_player
    @current_round = @game.current_round
    return unless @current_round.polling?

    @answer = @current_round.answers
      .find_or_initialize_by(player: @current_player)
  end

  private

  def game_params
    params.require(:game).permit(:question, :status)
  end
end
