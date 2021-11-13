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
      @new_round.players.each do |player|
        next if player == current_player

        Turbo::StreamsChannel.broadcast_update_later_to(
          player,
          target: "new_round_link",
          partial: "games/current_round_link",
          locals: { game: @new_round.game }
        )
      end
      redirect_to @new_round.game
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @param [Player]
  def current_player
    @current_player ||= Player.find_by!(id: params[:player_id], user: @user)
  end

  # @return [ActionController::Parameters]
  def new_round_params
    params.require(:new_round).permit(:question)
  end
end
