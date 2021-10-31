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
    @previous_round ||= Round.includes(:game).find_by!(
      id: params[:round_id],
      player: Player.where(
        game: Game.where(players: Player.where(user: @user))
      )
    )
  end

  # @return [Game]
  def game
    previous_round.game
  end

  # @return [Player]
  def current_player
    @current_player ||= game.players.find_by!(user: @user)
  end

  # @return [ActionController::Parameters]
  def new_round_params
    params.permit.merge(player: current_player, previous_round: previous_round)
  end
end
