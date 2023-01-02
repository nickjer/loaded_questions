# frozen_string_literal: true

class AnswerSwappersController < ApplicationController
  # POST /rounds/:round_id/answer_swappers
  def create
    round = Round.where(guesser: Player.active.where(user: @user))
      .find(params[:round_id])
    answer = Answer.where(participant: Participant.where(round:))
      .find(answer_swapper_params[:answer_id])
    other_answer = Answer.where(participant: Participant.where(round:))
      .find(answer_swapper_params[:swap_answer_id])

    respond_to do |format|
      if SwapAnswers.new(answer:, other_answer:).call
        round.game.active_players.each do |participating_player|
          next if participating_player == round.guesser

          PlayerChannel.broadcast_replace_later_to(
            participating_player,
            target: "guessed_#{dom_id(answer.guessed_participant)}",
            partial: "answers/answer",
            locals: { answer: }
          )
          PlayerChannel.broadcast_replace_later_to(
            participating_player,
            target: "guessed_#{dom_id(other_answer.guessed_participant)}",
            partial: "answers/answer",
            locals: { answer: other_answer }
          )
        end
        format.json { head :created }
      else
        PlayerChannel.broadcast_replace_later_to(
          round.guesser,
          target: "answers",
          partial: "matching_rounds/matching_round",
          locals: { round:, is_guesser: true }
        )
        format.json { head :bad_request }
      end
    end
  end

  private

  # @return [ActionController::Parameters]
  def answer_swapper_params
    params.require(:answer_swapper).permit(:answer_id, :swap_answer_id)
  end

  # @param target [Player, nil]
  # @return [String]
  def dom_id(target)
    ActionView::RecordIdentifier.dom_id(target)
  end
end
