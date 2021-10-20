# frozen_string_literal: true

class ActiveRoundsController < ApplicationController
  # GET /active_rounds/new
  def new
    @active_round = ActiveRound.new
  end

  # POST /active_rounds
  def create
    @active_round = ActiveRound.new(active_round_params)

    respond_to do |format|
      if @active_round.save
        format.html { redirect_to game, notice: "Active round was created." }
      else
        format.html do
          redirect_to game, notice: "Active round failed to be created."
        end
      end
    end
  end

  # DELETE /rounds/1
  def destroy
    Round
      .where(player: Player.where(user: @user), status: :active)
      .find(params[:id])
      .update(status: :completed)
    respond_to do |format|
      format.html do
        redirect_to game, notice: "Active round was destroyed."
      end
    end
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def active_round_params
    params.require(:active_round).permit.merge(game: game, user: @user)
  end
end
