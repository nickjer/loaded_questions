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
    steve = create_player("Steve", game_url: game_url)
    zombie = create_player("Zombie", game_url: game_url)

    # Alice's view
    using_session(alice.name) do
      assert_player bob, status: :active
      assert_player alice, status: :not_answered
      assert_player steve, status: :not_answered
      assert_player zombie, status: :not_answered
    end

    # Bob's view
    assert_player bob, status: :active
    assert_player alice, status: :not_answered
    assert_player steve, status: :not_answered
    assert_player zombie, status: :not_answered

    # Alice's view
    using_session(alice.name) do
      fill_in "answer_value", with: "Alice original answer"
      click_on "Create Answer"

      assert_text "Alice original answer"
      assert_player bob, status: :active
      assert_player alice, status: :answered
      assert_player steve, status: :not_answered
      assert_player zombie, status: :not_answered
    end

    # Bob's view
    assert_no_text "Alice original answer"
    assert_player bob, status: :active
    assert_player alice, status: :answered
    assert_player steve, status: :not_answered
    assert_player zombie, status: :not_answered

    # Steve's view
    using_session(steve.name) do
      fill_in "answer_value", with: "Steve answer"
      click_on "Create Answer"

      assert_text "Steve answer"
      assert_player bob, status: :active
      assert_player alice, status: :answered
      assert_player steve, status: :answered
      assert_player zombie, status: :not_answered
    end

    # Bob's view
    assert_no_text "Alice original answer"
    assert_player bob, status: :active
    assert_player alice, status: :answered
    assert_player steve, status: :answered
    assert_player zombie, status: :not_answered

    karen = create_player("Karen", game_url: game_url)

    # Bob's view
    assert_player bob, status: :active
    assert_player alice, status: :answered
    assert_player steve, status: :answered
    assert_player karen, status: :not_answered
    assert_player zombie, status: :not_answered

    # Alice's view
    using_session(alice.name) do
      fill_in "answer_value", with: "Alice answer"
      click_on "Update Answer"

      assert_text "Alice answer"
      assert_player bob, status: :active
      assert_player alice, status: :answered
      assert_player steve, status: :answered
      assert_player karen, status: :not_answered
      assert_player zombie, status: :not_answered
    end

    # Karen's view
    using_session(karen.name) do
      fill_in "answer_value", with: "Karen answer"
      click_on "Create Answer"

      assert_text "Karen answer"
      assert_player bob, status: :active
      assert_player alice, status: :answered
      assert_player steve, status: :answered
      assert_player karen, status: :answered
      assert_player zombie, status: :not_answered
    end

    # Bob's view
    assert_no_text "Alice answer"
    assert_no_text "Steve answer"
    assert_no_text "Karen answer"
    assert_player bob, status: :active
    assert_player alice, status: :answered
    assert_player steve, status: :answered
    assert_player karen, status: :answered
    assert_player zombie, status: :not_answered

    # Begin matching round
    click_on "Match Answers"

    assert_text "Are you sure"
    sleep 0.5
    click_on "Close"

    assert_text "Match Answers"
    click_on "Match Answers"
    sleep 0.5
    click_on "Yes, I am sure"
  end
end
