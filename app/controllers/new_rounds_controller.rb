# frozen_string_literal: true

class NewRoundsController < ApplicationController
  # GET /players/:player_id/new_rounds/new
  def new
    @new_round = NewRound.new(player: current_player)
  end

  # POST /players/:player_id/new_rounds
  def create
    @new_round = NewRound.new(player: current_player, params: new_round_params)

    if @new_round.save
      game = Game.find(@new_round.game.id) # work from latest data

      # Delete inactive players
      game.inactive_players.each do |inactive_player|
        inactive_player.update(deleted_at: Time.current)
      end

      # Show the Next Round link to all other players
      @new_round.players.each do |player|
        next if player == current_player

        PlayerChannel.broadcast_update_later_to(
          player,
          target: "new_new_round",
          partial: "games/current_round_link",
          locals: { game: }
        )
      end

      RedrawPlayersJob.perform_later(game)

      game_presenter = GamePresenter.new(game:, current_player:)
      render(
        turbo_stream: turbo_stream.update(:current_round,
          partial: "games/current_round", locals: { game: game_presenter })
      )
    else
      render :create, status: :unprocessable_entity
    end
  end

  private

  # @return [Player]
  def current_player
    @current_player ||= Player.find_by!(id: params[:player_id], user: @user)
  end

  # @return [ActionController::Parameters]
  def new_round_params
    params.require(:new_round).permit(:question, :hide_answers)
  end
end
