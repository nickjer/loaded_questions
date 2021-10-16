# frozen_string_literal: true

require "application_system_test_case"

class RoundsTest < ApplicationSystemTestCase
  setup { @round = rounds(:one) }

  test "visiting the index" do
    visit rounds_url
    assert_selector "h1", text: "Rounds"
  end

  test "should create Round" do
    visit rounds_url
    click_on "New Round"

    fill_in "Game", with: @round.game_id
    fill_in "Question", with: @round.question
    click_on "Create Round"

    assert_text "Round was successfully created"
    click_on "Back"
  end

  test "should update Round" do
    visit rounds_url
    click_on "Edit", match: :first

    fill_in "Game", with: @round.game_id
    fill_in "Question", with: @round.question
    click_on "Update Round"

    assert_text "Round was successfully updated"
    click_on "Back"
  end

  test "should destroy Round" do
    visit rounds_url
    page.accept_confirm { click_on "Destroy", match: :first }

    assert_text "Round was successfully destroyed"
  end
end
