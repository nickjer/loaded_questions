# frozen_string_literal: true

class CompletedRoundsController < ApplicationController
  # POST /rounds/:round_id/completed_rounds
  def create
    round = Round.find_by!(
      id: params[:round_id],
      player: Player.where(user: @user)
    )
    @completed_round = CompletedRound.new(round)

    if @completed_round.save
      @completed_round.players.each do |player|
        next if player == round.player

        PlayerChannel.broadcast_replace_later_to(
          player,
          target: "current_round",
          partial: "games/current_round_frame",
          locals: { game: @completed_round.game }
        )
      end
      redirect_to @completed_round.game
    else
      redirect_to @completed_round.game,
        notice: "Failed to proceed to completed round"
    end
  end
end
