# frozen_string_literal: true

class AnswerSwappersController < ApplicationController
  # POST /rounds/:round_id/answer_swappers
  def create
    @answer_swapper = AnswerSwapper.new(answer_swapper_params)

    respond_to do |format|
      if @answer_swapper.save
        answer = @answer_swapper.answer
        swap_answer = @answer_swapper.swap_answer

        round.game.players.each do |player|
          next if player == round.player

          Turbo::StreamsChannel.broadcast_replace_later_to(
            player,
            target: "guessed_#{dom_id(answer.guessed_player)}",
            partial: "answers/answer",
            locals: { answer: answer }
          )
          Turbo::StreamsChannel.broadcast_replace_later_to(
            player,
            target: "guessed_#{dom_id(swap_answer.guessed_player)}",
            partial: "answers/answer",
            locals: { answer: swap_answer }
          )
        end
        format.json { head :created }
      else
        Turbo::StreamsChannel.broadcast_replace_later_to(
          round.player,
          target: "answers",
          partial: "matching_rounds/matching_round",
          locals: { round: round, is_active_user: true }
        )
        format.json do
          render json: @answer_swapper.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  # @return [Round]
  def round
    @round ||= Round.find_by!(
      id: params[:round_id],
      player: Player.where(user: @user)
    )
  end

  # @return [ActionController::Parameters]
  def answer_swapper_params
    params.require(:answer_swapper).permit(:answer_id, :swap_answer_id)
      .merge(round: round)
  end

  # @param target [Player, nil]
  # @return [String]
  def dom_id(target)
    ActionView::RecordIdentifier.dom_id(target)
  end
end
