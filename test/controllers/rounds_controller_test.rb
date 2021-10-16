# frozen_string_literal: true

require "test_helper"

class RoundsControllerTest < ActionDispatch::IntegrationTest
  setup { @round = rounds(:one) }

  test "should get index" do
    get rounds_url
    assert_response :success
  end

  test "should get new" do
    get new_round_url
    assert_response :success
  end

  test "should create round" do
    assert_difference("Round.count") do
      post rounds_url,
        params: {
          round: {
            game_id: @round.game_id, question: @round.question
          }
        }
    end

    assert_redirected_to round_url(Round.last)
  end

  test "should show round" do
    get round_url(@round)
    assert_response :success
  end

  test "should get edit" do
    get edit_round_url(@round)
    assert_response :success
  end

  test "should update round" do
    patch round_url(@round),
      params: {
        round: {
          game_id: @round.game_id, question: @round.question
        }
      }
    assert_redirected_to round_url(@round)
  end

  test "should destroy round" do
    assert_difference("Round.count", -1) { delete round_url(@round) }

    assert_redirected_to rounds_url
  end
end
