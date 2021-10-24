# frozen_string_literal: true

class MatchingRoundsController < ApplicationController
  before_action :check_permissions

  # GET /matching_rounds/new
  def new
    @matching_round = MatchingRound.new
  end

  # POST /matching_rounds
  def create
    @matching_round = MatchingRound.new(matching_round_params)

    if @matching_round.save
      redirect_to @matching_round.game, notice: "Begin matching round"
    else
      redirect_to @matching_round.game,
        notice: "Failed to proceed to matching round"
    end
  end

  private

  def round
    @round ||= Round.find(params[:round_id])
  end

  def matching_round_params
    params.permit.merge(round: round)
  end

  def check_permissions
    return if round.player.user == @user

    redirect_to round.game,
      notice: "You do not have permissions to begin matching round"
  end
end
