# frozen_string_literal: true

class NewRoundsController < ApplicationController
  # GET /new_rounds/new
  def new
    @new_round = NewRound.new
  end

  # POST /new_rounds
  def create
    @new_round = NewRound.new(new_round_params)

    if @new_round.save
      redirect_to game, notice: "New round was created."
    else
      redirect_to game, notice: "New round failed to be created."
    end
  end

  private

  def previous_round
    @previous_round ||= Round.find(params[:round_id])
  end

  def game
    previous_round.game
  end

  def current_player
    @current_player ||= game.players.find_by!(user: @user)
  end

  def new_round_params
    params.require(:new_round).permit
      .merge(player: current_player, previous_round: previous_round)
  end
end
