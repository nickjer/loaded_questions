# frozen_string_literal: true

class GamesController < ApplicationController
  # GET /games
  def index
    @games = Game.all
  end

  # GET /games/1
  def show
    @game = Game.find(params[:id])
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: "Game was created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  def update
    @game = Game.find(params[:id])
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: "Game was updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was destroyed." }
    end
  end

  private

  def game_params
    params.require(:game).permit(:question, :status)
  end
end
