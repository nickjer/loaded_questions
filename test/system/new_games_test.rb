# frozen_string_literal: true

require "application_system_test_case"

class NewGamesTest < ApplicationSystemTestCase
  def create_player(player, game_url:)
    using_session(player) do
      visit game_url
      fill_in "Name", with: player
      click_on "Create Player"
    end
    Player.find_by!(name: player)
  end

  def assert_player(player, status:)
    assert_selector :id, dom_id(player) do |player_element|
      icon = {
        active: "i.bi-star-fill",
        not_answered: "i.bi-square",
        answered: "i.bi-check-square"
      }.fetch(status.to_sym)
      player_element.assert_selector icon
      player_element.assert_text player.name
    end
  end

  test "should create New Game" do
    visit new_new_game_url
    fill_in "Player name", with: "Bob"
    fill_in "Question", with: "How high is the sky?"
    click_on "Create New Game"

    assert_text "Match Answers"
    assert_text "Bob"

    bob = Player.find_by!(name: "Bob")
    assert_player(bob, status: :active)
    game_url = current_url

    alice = create_player("Alice", game_url: game_url)

    # Alice's view
    using_session(alice.name) do
      assert_player bob, status: :active
      assert_player alice, status: :not_answered
    end

    # Bob's view
    assert_player bob, status: :active
    assert_player alice, status: :not_answered

    # Alice's view
    using_session(alice.name) do
      fill_in "answer_value", with: "Alice original answer"
      click_on "Create Answer"

      assert_text "Alice original answer"
      assert_player bob, status: :active
      assert_player alice, status: :answered
    end

    # Bob's view
    assert_no_text "Alice original answer"
    assert_player bob, status: :active
    assert_player alice, status: :answered

    # Alice's view
    using_session(alice.name) do
      fill_in "answer_value", with: "Alice answer"
      click_on "Update Answer"

      assert_text "Alice answer"
      assert_player bob, status: :active
      assert_player alice, status: :answered
    end

    # Bob's view
    assert_no_text "Alice answer"
    assert_player bob, status: :active
    assert_player alice, status: :answered
  end
end
