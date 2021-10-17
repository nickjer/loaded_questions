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
    @player = game.players.build
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  def create
    @player = game.players.build(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: "Player was created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  def update
    @player = Player.find(params[:id])
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: "Player was updated." }
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
    params.require(:player).permit(:name).merge(user: @user)
  end
end
