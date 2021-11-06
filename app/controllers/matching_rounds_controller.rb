# frozen_string_literal: true

class MatchingRoundsController < ApplicationController
  # GET /matching_rounds/new
  def new
    @matching_round = MatchingRound.new
  end

  # POST /matching_rounds
  def create
    @matching_round = MatchingRound.new(matching_round_params)

    if @matching_round.save
      Turbo::StreamsChannel.broadcast_update_to(
        @matching_round.game,
        target: "round_body",
        partial: "matching_rounds/matching_round",
        locals: { round: @round, is_active_user: false }
      )
      redirect_to @matching_round.game
    else
      redirect_to @matching_round.game,
        notice: "Failed to proceed to matching round"
    end
  end

  private

  def round
    @round ||= Round.find_by!(
      id: params[:round_id],
      player: Player.where(user: @user)
    )
  end

  def matching_round_params
    params.permit.merge(round: round)
  end
end
