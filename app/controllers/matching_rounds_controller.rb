# frozen_string_literal: true

class MatchingRoundsController < ApplicationController
  # GET /matching_rounds/new
  def new
    @matching_round = MatchingRound.new
  end

  # POST /matching_rounds
  def create
    round =
      Round.find_by!(id: params[:round_id], player: Player.where(user: @user))
    @matching_round =
      MatchingRound.new(matching_round_params.merge(round: round))

    if @matching_round.save
      Turbo::StreamsChannel.broadcast_replace_later_to(
        @matching_round.game,
        target: round,
        partial: "rounds/round_frame",
        locals: { round: round }
      )
      redirect_to @matching_round.game
    else
      redirect_to @matching_round.game,
        notice: "Failed to proceed to matching round"
    end
  end

  private

  def matching_round_params
    params.permit
  end
end
