# frozen_string_literal: true

class GameConfigurationsController < ApplicationController
  # GET /game_configurations/new
  def new
    @game_configuration = GameConfiguration.new
  end

  # POST /game_configurations
  def create
    @game_configuration = GameConfiguration.new(game_configuration_params)

    if @game_configuration.save
      redirect_to @game_configuration.game, notice: "Game was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def game_configuration_params
    params.require(:game_configuration).permit(:player_name)
  end
end
