# frozen_string_literal: true

class GamePresenter
  # @return [Game]
  attr_reader :game

  # @return [Player]
  attr_reader :current_player

  # @param game [Game]
  # @param current_player [Player]
  def initialize(game:, current_player:)
    @game = game
    @current_player = current_player

    if current_player.blank?
      raise "Game presenter needs a current player to present to"
    end

    raise "Game presenter needs a current round to draw" if current_round.blank?
  end

  # @!method polling?
  #   @return [Boolean]
  delegate :polling?, to: :current_round

  # @!method matching?
  #   @return [Boolean]
  delegate :matching?, to: :current_round

  # @!method completed?
  #   @return [Boolean]
  delegate :completed?, to: :current_round

  # @!method current_round
  #   @return [Round]
  delegate :current_round, to: :game

  # @!method active_player
  #   @return [Player]
  delegate :active_player, to: :game

  # @!method players
  #   @return [Player::ActiveRecord_Associations_CollectionProxy]
  delegate :players, to: :game

  # @return [Boolean]
  def active_player?
    current_player == active_player
  end

  # @return [Answer, nil]
  def current_player_answer
    return if active_player? || !polling?

    @current_player_answer ||=
      current_round.answers.find_or_initialize_by(player: current_player)
  end
end
