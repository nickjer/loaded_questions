# frozen_string_literal: true

class AnswerSwappersController < ApplicationController
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
    @round ||= Round.find_by!(
      id: params[:round_id],
      player: Player.where(user: @user)
    )
  end

  def answer_swapper_params
    params.require(:answer_swapper).permit(:answer_id, :swap_answer_id)
      .merge(round: round)
  end
end
