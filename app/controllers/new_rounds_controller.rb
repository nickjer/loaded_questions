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
      redirect_to game, notice: "New round was created"
    else
      redirect_to game, notice: "New round failed to be created"
    end
  end

  private

  def player
    @player ||= Player.find_by!(id: params[:player_id], user: @user)
  end

  # @return [Game]
  def game
    player.game
  end

  # @return [ActionController::Parameters]
  def new_round_params
    params.permit.merge(player: player)
  end
end
