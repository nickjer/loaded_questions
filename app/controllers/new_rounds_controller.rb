# frozen_string_literal: true

class NewRoundsController < ApplicationController
  # GET /players/:player_id/new_rounds/new
  def new
    @new_round = NewRound.new(player: current_player)
  end

  # POST /players/:player_id/new_rounds
  def create
    @new_round = NewRound.new(player: current_player, params: new_round_params)

    if @new_round.save
      # Refresh the cache, in particular the `Game#current_round`
      game = Game.find(@new_round.game.id)

      # Delete inactive players
      game.inactive_players.each do |inactive_player|
        inactive_player.update(deleted_at: Time.current)
      end

      # Update all other players
      @new_round.players.each do |player|
        next if player == current_player

        PlayerChannel.broadcast_update_later_to(
          player,
          target: "new_round_link",
          partial: "games/current_round_link",
          locals: { game: }
        )

        # Redraw all players to set up for new round state
        PlayerChannel.broadcast_replace_to(
          player,
          target: "players",
          partial: "games/players_frame",
          locals: { game: }
        )
      end
      redirect_to game
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @return [Player]
  def current_player
    @current_player ||= Player.find_by!(id: params[:player_id], user: @user)
  end

  # @return [ActionController::Parameters]
  def new_round_params
    params.require(:new_round).permit(:question, :hide_answers)
  end
end
