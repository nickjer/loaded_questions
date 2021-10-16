# frozen_string_literal: true

class GameConfiguration
  include ActiveModel::Model

  attr_accessor :player_name, :question

  validates :player_name, :question, presence: true

  def save
    valid?
  end
end
