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
      Turbo::StreamsChannel.broadcast_update_to(
        @matching_round.game,
        target: "round_body",
        partial: "matching_rounds/matching_round_frame",
        locals: { round: round }
      )
      redirect_to @matching_round.game
    else
      redirect_to @matching_round.game,
        notice: "Failed to proceed to matching round"
    end
  end

  def show
    round = Round.find(params[:id])
    current_player = Player.find_by!(
      user: @user, game: Game.where(players: Player.where(rounds: round))
    )

    render partial: "matching_rounds/matching_round",
      locals: { round: round, is_active_user: round.player == current_player }
  end

  private

  def matching_round_params
    params.permit
  end
end
