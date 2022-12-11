# frozen_string_literal: true

require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup { @user = users(:one) }

  test "visiting the index" do
    visit users_url

    assert_selector "h1", text: "Users"
  end

  test "should create User" do
    visit users_url
    click_on "New User"

    fill_in "Current sign in at", with: @user.current_sign_in_at
    fill_in "Last sign in at", with: @user.last_sign_in_at
    fill_in "Name", with: @user.name
    fill_in "Sign in count", with: @user.sign_in_count
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  test "should update User" do
    visit users_url
    click_on "Edit", match: :first

    fill_in "Current sign in at", with: @user.current_sign_in_at
    fill_in "Last sign in at", with: @user.last_sign_in_at
    fill_in "Name", with: @user.name
    fill_in "Sign in count", with: @user.sign_in_count
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"
  end

  test "should destroy User" do
    visit users_url
    page.accept_confirm { click_on "Destroy", match: :first }

    assert_text "User was successfully destroyed"
  end
end
