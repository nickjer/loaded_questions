# frozen_string_literal: true

class AnswersController < ApplicationController
  # POST /participants/:participant_id/answers
  def create
    participant = Participant.where(
      player: Player.active.where(user: @user),
      round: Round.polling
    ).find(params[:participant_id])

    @answer = participant.build_answer(answer_params)

    if @answer.save
      player = participant.player
      player.game.active_players.each do |participating_player|
        PlayerChannel.broadcast_update_to(
          participating_player,
          targets: player.selector_for(:answered),
          partial: "players/answered",
          locals: { answered: true }
        )
      end
      PlayerChannel.broadcast_replace_to(
        player.game.current_guesser,
        target: "match_answers",
        partial: "matching_rounds/match_answers",
        locals: { round: player.game.current_round }
      )
      render :update
    else
      render :create, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/:id
  def update
    @answer = Answer.where(
      participant: Participant.where(
        player: Player.active.where(user: @user),
        round: Round.polling
      )
    ).find(params[:id])

    if @answer.update(answer_params)
      render :update
    else
      render :update, status: :unprocessable_entity
    end
  end

  private

  # @return [ActionController::Parameters]
  def answer_params
    params.require(:answer).permit(:value)
  end
end
