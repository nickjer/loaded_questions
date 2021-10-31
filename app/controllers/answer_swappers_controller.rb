# frozen_string_literal: true

class AnswerSwappersController < ApplicationController
  before_action :check_permissions

  # GET /answer_swappers/new
  def new
    @answer_swapper = AnswerSwapper.new
  end

  # POST /answer_swappers
  def create
    @answer_swapper = AnswerSwapper.new(answer_swapper_params)

    respond_to do |format|
      if @answer_swapper.save
        format.json { head :created }
      else
        format.json do
          render json: @answer_swapper.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def round
    @round ||= Round.find(params[:round_id])
  end

  def answer_swapper_params
    params.require(:answer_swapper).permit(:answer_id, :swap_answer_id)
      .merge(round: round)
  end

  def check_permissions
    return if round.player.user == @user

    redirect_to round.game,
      notice: "You do not have permissions to begin matching round"
  end
end
