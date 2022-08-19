# frozen_string_literal: true

class AnswersController < ApplicationController
  # POST /rounds/:round_id/answers
  def create
    round = Round.find(params[:round_id])
    current_player = round.game.players.find_by!(user: @user)
    @answer = round.answers.where(player: current_player).build(answer_params)

    if @answer.save
      RedrawPlayerJob.perform_later(current_player)
      render :update
    else
      render :create, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/:id
  def update
    @answer = Answer.where(player: Player.where(user: @user)).find(params[:id])

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
