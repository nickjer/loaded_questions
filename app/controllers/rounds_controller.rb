# frozen_string_literal: true

class RoundsController < ApplicationController
  # GET /rounds
  def index
    @rounds = player.rounds
  end

  # GET /rounds/1
  def show
    @round = Round.find(params[:id])
  end

  # GET /rounds/new
  def new
    @round = player.rounds.build
  end

  # GET /rounds/1/edit
  def edit
    @round = Round.find(params[:id])
  end

  # POST /rounds
  def create
    @round = player.rounds.build(round_params)

    respond_to do |format|
      if @round.save
        format.html { redirect_to @round.game, notice: "Round was created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rounds/1
  def update
    @round = Round.find(params[:id])
    respond_to do |format|
      if @round.update(round_params)
        format.html { redirect_to @round.game, notice: "Round was updated." }
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

  def player
    @player ||= Player.find(params[:player_id])
  end

  def round_params
    params.require(:round).permit(:question)
  end
end
