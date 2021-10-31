# frozen_string_literal: true

class CompletedRoundsController < ApplicationController
  # GET /completed_rounds/new
  def new
    @completed_round = CompletedRound.new
  end

  # POST /completed_rounds
  def create
    @completed_round = CompletedRound.new(completed_round_params)

    if @completed_round.save
      redirect_to @completed_round.game, notice: "Begin completed round"
    else
      redirect_to @completed_round.game,
        notice: "Failed to proceed to completed round"
    end
  end

  private

  def round
    @round ||= Round.find_by!(
      id: params[:round_id],
      player: Player.where(user: @user)
    )
  end

  def completed_round_params
    params.permit.merge(round: round)
  end
end
