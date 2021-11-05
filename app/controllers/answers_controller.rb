# frozen_string_literal: true

class AnswersController < ApplicationController
  # GET /answers
  def index
    @answers = round.answers
  end

  # GET /answers/1
  def show
    @answer = Answer.find(params[:id])
  end

  # GET /answers/new
  def new
    @answer = round.answers.build(player: current_player)
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /answers
  def create
    @answer = round.answers.where(player: current_player).build(answer_params)

    if @answer.save
      Turbo::StreamsChannel.broadcast_update_to(
        game,
        target: @current_player,
        partial: "players/player",
        locals: { player: @current_player, active_player: game.active_player }
      )
      redirect_to game
    else
      redirect_to game, notice: "Answer failed to be created."
    end
  end

  # PATCH/PUT /answers/1
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to game }
      else
        format.html { redirect_to game, notice: "Answer failed to be created." }
      end
    end
  end

  # DELETE /answers/1
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    respond_to { |format| format.html { redirect_to answers_url } }
  end

  private

  def round
    @round ||= Round.find(params[:round_id])
  end

  def game
    @game ||= round.game
  end

  def current_player
    @current_player ||= game.players.find_by!(user: @user)
  end

  def answer_params
    params.require(:answer).permit(:value)
  end
end
