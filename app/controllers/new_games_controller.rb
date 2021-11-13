# frozen_string_literal: true

class NewGamesController < ApplicationController
  # GET /new_games/new
  def new
    @new_game = NewGame.new(user: @user)
  end

  # POST /new_games
  def create
    @new_game = NewGame.new(user: @user, params: new_game_params)

    if @new_game.save
      redirect_to game_path(@new_game.game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def new_game_params
    params.require(:new_game).permit(:player_name, :question)
  end
end
