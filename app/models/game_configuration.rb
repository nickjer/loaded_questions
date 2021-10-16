# frozen_string_literal: true

class GameConfiguration
  include ActiveModel::Model

  attr_accessor :player_name

  attr_reader :game

  validates :player_name, presence: true

  def save
    valid?
  end
end
