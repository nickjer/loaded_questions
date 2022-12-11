# frozen_string_literal: true

require "application_system_test_case"

class PlayersTest < ApplicationSystemTestCase
  setup { @player = players(:one) }

  test "visiting the index" do
    visit players_url

    assert_selector "h1", text: "Players"
  end

  test "should create Player" do
    visit players_url
    click_on "New Player"

    fill_in "Game", with: @player.game_id
    fill_in "Name", with: @player.name
    fill_in "User", with: @player.user_id
    click_on "Create Player"

    assert_text "Player was successfully created"
    click_on "Back"
  end

  test "should update Player" do
    visit players_url
    click_on "Edit", match: :first

    fill_in "Game", with: @player.game_id
    fill_in "Name", with: @player.name
    fill_in "User", with: @player.user_id
    click_on "Update Player"

    assert_text "Player was successfully updated"
    click_on "Back"
  end

  test "should destroy Player" do
    visit players_url
    page.accept_confirm { click_on "Destroy", match: :first }

    assert_text "Player was successfully destroyed"
  end
end
