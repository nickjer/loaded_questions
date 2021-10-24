# frozen_string_literal: true

class NewGamesController < ApplicationController
  # GET /new_games/new
  def new
    @new_game = NewGame.new
  end

  # POST /new_games
  def create
    @new_game = NewGame.new(new_game_params)

    if @new_game.save
      redirect_to game_path(@new_game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def new_game_params
    params.require(:new_game).permit(:player_name).merge(user: @user)
  end
end
