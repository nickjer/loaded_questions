# frozen_string_literal: true

require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  setup { @player = players(:one) }

  test "should get index" do
    get players_url
    assert_response :success
  end

  test "should get new" do
    get new_player_url
    assert_response :success
  end

  test "should create player" do
    assert_difference("Player.count") do
      post players_url,
        params: { player: { game_id: @player.game_id, name: @player.name,
                            user_id: @player.user_id } }
    end

    assert_redirected_to player_url(Player.last)
  end

  test "should show player" do
    get player_url(@player)
    assert_response :success
  end

  test "should get edit" do
    get edit_player_url(@player)
    assert_response :success
  end

  test "should update player" do
    patch player_url(@player),
      params: { player: { game_id: @player.game_id, name: @player.name,
                          user_id: @player.user_id } }
    assert_redirected_to player_url(@player)
  end

  test "should destroy player" do
    assert_difference("Player.count", -1) { delete player_url(@player) }

    assert_redirected_to players_url
  end
end
