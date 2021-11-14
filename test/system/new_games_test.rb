# frozen_string_literal: true

require "application_system_test_case"

class NewGamesTest < ApplicationSystemTestCase
  test "should create New Game" do
    visit new_new_game_url
    fill_in "Player name", with: "Bob"
    fill_in "Question", with: "How high is the sky?"
    click_on "Create New Game"

    assert_text "Match Answers"

    game_url = current_url

    using_session("Alice") do
      visit game_url
      fill_in "Name", with: "Alice"
      click_on "Create Player"

      assert_text "Bob"
    end
  end

  # test "should create Game" do
  #   visit games_url
  #   click_on "New Game"

  #   fill_in "Question", with: @game.question
  #   fill_in "Status", with: @game.status
  #   click_on "Create Game"

  #   assert_text "Game was successfully created"
  #   click_on "Back"
  # end

  # test "should update Game" do
  #   visit games_url
  #   click_on "Edit", match: :first

  #   fill_in "Question", with: @game.question
  #   fill_in "Status", with: @game.status
  #   click_on "Update Game"

  #   assert_text "Game was successfully updated"
  #   click_on "Back"
  # end

  # test "should destroy Game" do
  #   visit games_url
  #   page.accept_confirm { click_on "Destroy", match: :first }

  #   assert_text "Game was successfully destroyed"
  # end
end
