# frozen_string_literal: true

class GameConfigurationsController < ApplicationController
  # GET /game_configurations/new
  def new
    @game_configuration = GameConfiguration.new
  end

  # POST /game_configurations
  def create
    @game_configuration = GameConfiguration.new(game_configuration_params)

    if (game = @game_configuration.create_game)
      redirect_to game, notice: "Game was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def game_configuration_params
    params.require(:game_configuration).permit(:player_name).merge(user: @user)
  end
end
