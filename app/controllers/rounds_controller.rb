# frozen_string_literal: true

class RoundsController < ApplicationController
  # GET /rounds
  def index
    @rounds = game.rounds
  end

  # GET /rounds/1
  def show
    @round = Round.find(params[:id])
    @current_player = Player.find_by!(
      user: @user, game: Game.where(players: Player.where(rounds: @round))
    )

    return unless turbo_frame_request?

    render partial: "rounds/round",
      locals: {
        round: @round,
        is_active_user: @round.player == @current_player
      }
  end

  # GET /rounds/new
  def new
    @round = game.rounds.build(player: current_player)
  end

  # GET /rounds/1/edit
  def edit
    @round = Round.find(params[:id])
  end

  # POST /rounds
  def create
    respond_to do |format|
      if CreateRound.new(current_player).call
        format.html { redirect_to game, notice: "Round was created." }
      else
        format.html do
          redirect_to game, notice: "Round failed to be created."
        end
      end
    end
  end

  # PATCH/PUT /rounds/1
  def update
    @round = Round.find(params[:id])
    respond_to do |format|
      if @round.update(round_params)
        format.html { redirect_to game, notice: "Round was updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rounds/1
  def destroy
    @round = Round.find(params[:id])
    @round.destroy
    respond_to do |format|
      format.html { redirect_to rounds_url, notice: "Round was destroyed." }
    end
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def current_player
    @current_player ||= game.players.find_by!(user: @user)
  end

  def round_params
    params.require(:round).permit(:question, :status)
  end
end
