# frozen_string_literal: true

class PlayersController < ApplicationController
  # GET /players
  def index
    @players = game.players
  end

  # GET /players/1
  def show
    @player = Player.find(params[:id])
  end

  # GET /players/new
  def new
    @player = game.players.where(user: @user).build
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  def create
    @player = game.players.where(user: @user).build(player_params)

    if @player.save
      Turbo::StreamsChannel.broadcast_append_to(
        game,
        target: "players",
        partial: "players/player",
        locals: { player: @player, active_player: game.active_player }
      )
      redirect_to @player.game
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /players/1
  def update
    @player = Player.find(params[:id])
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player.game }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  def destroy
    @player = Player.find(params[:id])
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: "Player was destroyed." }
    end
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def player_params
    params.require(:player).permit(:name)
  end
end
