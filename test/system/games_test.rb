# frozen_string_literal: true

require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  setup { @game = games(:one) }

  test "visiting the index" do
    visit games_url
    assert_selector "h1", text: "Games"
  end

  test "should create Game" do
    visit games_url
    click_on "New Game"

    fill_in "Question", with: @game.question
    fill_in "Status", with: @game.status
    click_on "Create Game"

    assert_text "Game was successfully created"
    click_on "Back"
  end

  test "should update Game" do
    visit games_url
    click_on "Edit", match: :first

    fill_in "Question", with: @game.question
    fill_in "Status", with: @game.status
    click_on "Update Game"

    assert_text "Game was successfully updated"
    click_on "Back"
  end

  test "should destroy Game" do
    visit games_url
    page.accept_confirm { click_on "Destroy", match: :first }

    assert_text "Game was successfully destroyed"
  end
end
