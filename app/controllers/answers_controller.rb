# frozen_string_literal: true

class AnswersController < ApplicationController
  # GET /rounds/:round_id/answers/new
  def new
    @round = Round.find(params[:round_id])
    @current_player = @round.game.players.find_by!(user: @user)

    @answer = @round.answers.build(player: @current_player)
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /rounds/:round_id/answers
  def create
    @round = Round.find(params[:round_id])
    @current_player = @round.game.players.find_by!(user: @user)

    @answer = @round.answers.where(player: @current_player).build(answer_params)

    if @answer.save
      @round.game.players.each do |player|
        Turbo::StreamsChannel.broadcast_replace_later_to(
          player,
          target: @current_player,
          partial: "players/player",
          locals: { player: @current_player, active_player: @round.player }
        )
      end
      redirect_to @round.game
    else
      redirect_to @round.game, notice: "Answer failed to be created."
    end
  end

  # PATCH/PUT /answers/1
  def update
    @answer = Answer.where(player: Player.where(user: @user)).find(params[:id])

    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer.game }
      else
        format.html do
          redirect_to @answer.game, notice: "Answer failed to be updated."
        end
      end
    end
  end

  private

  # @return [ActionController::Parameters]
  def answer_params
    params.require(:answer).permit(:value)
  end
end
