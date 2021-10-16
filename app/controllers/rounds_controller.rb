# frozen_string_literal: true

class RoundsController < ApplicationController
  # GET /rounds
  def index
    @rounds = Round.all
  end

  # GET /rounds/1
  def show
    @round = Round.find(params[:id])
  end

  # GET /rounds/new
  def new
    @round = Round.new
  end

  # GET /rounds/1/edit
  def edit
    @round = Round.find(params[:id])
  end

  # POST /rounds
  def create
    @round = Round.new(round_params)

    respond_to do |format|
      if @round.save
        format.html { redirect_to @round, notice: "Round was created." }
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
        format.html { redirect_to @round, notice: "Round was updated." }
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

  def round_params
    params.require(:round).permit(:game_id, :question)
  end
end
