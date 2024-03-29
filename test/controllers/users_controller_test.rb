# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "should get index" do
    get users_url

    assert_response :success
  end

  test "should get new" do
    get new_user_url

    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url,
        params: {
          user: {
            current_sign_in_at: @user.current_sign_in_at,
            last_sign_in_at: @user.last_sign_in_at,
            name: @user.name,
            sign_in_count: @user.sign_in_count
          }
        }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)

    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)

    assert_response :success
  end

  test "should update user" do
    patch user_url(@user),
      params: {
        user: {
          current_sign_in_at: @user.current_sign_in_at,
          last_sign_in_at: @user.last_sign_in_at,
          name: @user.name,
          sign_in_count: @user.sign_in_count
        }
      }

    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference("User.count", -1) { delete user_url(@user) }

    assert_redirected_to users_url
  end
end
