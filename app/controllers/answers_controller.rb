# frozen_string_literal: true

class AnswersController < ApplicationController
  # POST /rounds/:round_id/answers
  def create
    @round = Round.find(params[:round_id])
    @current_player = @round.game.players.find_by!(user: @user)

    @answer = @round.answers.where(player: @current_player).build(answer_params)

    if @answer.save
      @round.game.players.each do |player|
        PlayerChannel.broadcast_replace_later_to(
          player,
          target: @current_player,
          partial: "players/player",
          locals: {
            player: @current_player, active_player: @round.player, me: player
          }
        )
      end
      render turbo_stream: answer_form(answer: @answer)
    else
      render turbo_stream: answer_form(answer: @answer, round: @round),
        status: :unprocessable_entity
    end
  end

  # PATCH/PUT /answers/1
  def update
    @answer = Answer.where(player: Player.where(user: @user)).find(params[:id])

    if @answer.update(answer_params)
      render turbo_stream: answer_form(answer: @answer)
    else
      render turbo_stream: answer_form(answer: @answer),
        status: :unprocessable_entity
    end
  end

  private

  # @return [ActionController::Parameters]
  def answer_params
    params.require(:answer).permit(:value)
  end

  # @param answer [Answer]
  # @param round [Round, nil]
  # @return [String]
  def answer_form(answer:, round: nil)
    turbo_stream.replace(
      "answer_form",
      partial: "form",
      locals: { answer:, round: }
    )
  end
end
