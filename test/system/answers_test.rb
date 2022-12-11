# frozen_string_literal: true

require "application_system_test_case"

class AnswersTest < ApplicationSystemTestCase
  setup { @answer = answers(:one) }

  test "visiting the index" do
    visit answers_url

    assert_selector "h1", text: "Answers"
  end

  test "should create Answer" do
    visit answers_url
    click_on "New Answer"

    fill_in "Player", with: @answer.player_id
    fill_in "Round", with: @answer.round_id
    fill_in "Value", with: @answer.value
    click_on "Create Answer"

    assert_text "Answer was successfully created"
    click_on "Back"
  end

  test "should update Answer" do
    visit answers_url
    click_on "Edit", match: :first

    fill_in "Player", with: @answer.player_id
    fill_in "Round", with: @answer.round_id
    fill_in "Value", with: @answer.value
    click_on "Update Answer"

    assert_text "Answer was successfully updated"
    click_on "Back"
  end

  test "should destroy Answer" do
    visit answers_url
    page.accept_confirm { click_on "Destroy", match: :first }

    assert_text "Answer was successfully destroyed"
  end
end
