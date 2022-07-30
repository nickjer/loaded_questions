# frozen_string_literal: true

class NewGame
  include FormModel

  # @return [User]
  attr_reader :user

  # @return [String]
  attr_reader :player_name

  # @return [String]
  attr_reader :question

  # @return [Boolean]
  attr_reader :hide_answers

  # Validations
  validates :user, presence: true
  validates :player_name, presence: true
  validates :question, presence: true
  validates :hide_answers, inclusion: [true, false]

  # @param user [User]
  # @param params [#to_h]
  def initialize(user:, params: nil)
    @user = user

    params = params.to_h.deep_symbolize_keys
    @player_name = params[:player_name].to_s.squish
    @question = params[:question].to_s.squish
    @hide_answers = ActiveModel::Type::Boolean.new.cast(params[:hide_answers])
  end

  # @return [Game]
  def game
    @game ||= Game.new(
      players: [
        Player.new(
          user:,
          name: player_name,
          rounds: [Round.new(question:, hide_answers:)]
        )
      ]
    )
  end

  # @return [Boolean]
  def save
    return false unless valid?

    game.save
  end
end
