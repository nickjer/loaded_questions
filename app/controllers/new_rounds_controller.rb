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

  # @return [Round]
  def previous_round
    @previous_round ||= Round.find(params[:round_id])
  end

  # @return [Game]
  def game
    previous_round.game
  end

  # @return [Player, nil]
  def current_player
    @current_player ||= game.players.find_by(user: @user)
  end

  # @return [ActionController::Parameters]
  def new_round_params
    params.permit.merge(player: current_player, previous_round: previous_round)
  end

  # @return [void]
  def check_permissions
    return if current_player.present?

    redirect_to game, notice: "You do not have permissions to create new round"
  end
end
