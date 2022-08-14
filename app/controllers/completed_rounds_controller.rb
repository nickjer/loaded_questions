# frozen_string_literal: true

class CompletedRoundsController < ApplicationController
  # POST /rounds/:round_id/completed_rounds
  def create
    round =
      Round.find_by!(id: params[:round_id], player: Player.where(user: @user))
    completed_round = CompletedRound.new(round)

    if completed_round.save
      game = Game.find(round.game.id) # work from latest data
      status = :created
      RedrawCurrentRoundJob.perform_later(game, except_to: round.player)
    else
      game = round.game
      status = :unprocessable_entity
    end

    @game = GamePresenter.new(game:, current_player: round.player)
    render(:create, status:)
  end
end
