# frozen_string_literal: true

class AnswersController < ApplicationController
  # GET /answers
  def index
    @round = Round.find(params[:round_id])
    @answers = @round.answers
  end

  # GET /answers/1
  def show
    @answer = Answer.find(params[:id])
  end

  # GET /answers/new
  def new
    @round = Round.find(params[:round_id])
    @current_player = @round.game.players.find_by!(user: @user)

    @answer = @round.answers.build(player: @current_player)
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /answers
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
          redirect_to @answer.game, notice: "Answer failed to be created."
        end
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

  def current_player
    @current_player ||= game.players.find_by!(user: @user)
  end

  def answer_params
    params.require(:answer).permit(:value)
  end
end
