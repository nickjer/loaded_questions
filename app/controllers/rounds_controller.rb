# frozen_string_literal: true

class RoundsController < ApplicationController
  # GET /rounds/1
  def show
    @round = Round.find(params[:id])
    @current_player = Player.find_by!(
      user: @user, game: Game.where(players: Player.where(rounds: @round))
    )
  end

  # PATCH/PUT /rounds/1
  def update
    @round = Round.where(player: Player.where(user: @user)).find(params[:id])

    if @round.update(round_params)
      @round.game.players.each do |player|
        next if player == @round.player

        Turbo::StreamsChannel.broadcast_replace_later_to(
          player,
          target: "current_round",
          partial: "games/current_round_frame",
          locals: { game: @round.game }
        )
      end
      redirect_to @round.game
    else
      redirect_to @round.game, notice: "Failed to update round"
    end
  end

  private

  # @return [ActionController::Parameters]
  def round_params
    params.require(:round).permit(:hide_answers)
  end
end
