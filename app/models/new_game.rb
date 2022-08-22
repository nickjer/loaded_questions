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
  validates :player_name, length: { in: 3..20 }
  validates :question, length: { in: 3..160 }
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
      slug: generate_slug,
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

  private

  # @return [String]
  def generate_slug
    loop do
      slug = NOUN_LIST.shuffle.take(4).join("-")
      break slug unless Game.exists?(slug:)
    end
  end
end
