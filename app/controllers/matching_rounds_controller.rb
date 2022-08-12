# frozen_string_literal: true

class MatchingRoundsController < ApplicationController
  # POST /rounds/:round_id/matching_rounds
  def create
    round = Round.find_by!(
      id: params[:round_id],
      player: Player.where(user: @user)
    )
    @matching_round = MatchingRound.new(round)

    if @matching_round.save
      @matching_round.players.each do |player|
        next if player == round.player

        PlayerChannel.broadcast_replace_later_to(
          player,
          target: "current_round",
          partial: "games/current_round_frame",
          locals: { game: @matching_round.game }
        )
      end
      redirect_to @matching_round.game
    else
      redirect_to @matching_round.game,
        notice: "Failed to proceed to matching round"
    end
  end
end
