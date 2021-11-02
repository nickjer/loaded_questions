# frozen_string_literal: true

class NewRoundsController < ApplicationController
  # GET /new_rounds/new
  def new
    @new_round = NewRound.new(player: player)
  end

  # POST /new_rounds
  def create
    @new_round = NewRound.new(new_round_params)

    if @new_round.save
      redirect_to player.game
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def player
    @player ||= Player.find_by!(id: params[:player_id], user: @user)
  end

  # @return [ActionController::Parameters]
  def new_round_params
    params.require(:new_round).permit(:question).merge(player: player)
  end
end
