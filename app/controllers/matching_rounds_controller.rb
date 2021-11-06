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
        target: "current_round",
        partial: "rounds/round",
        locals: { round: @round, answer: nil, is_active_player: false }
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
