require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  test "user can sign up" do
    visit signup_url

    fill_in "Name", with: "New User"
    fill_in "email", with: "newuser@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    # Use find and click to be more specific about which button to click
    find('input[type="submit"][value="Sign Up"]').click

    assert_selector ".bg-green-100", text: "Welcome to Sensible Rails Lite!"
    assert_selector "nav", text: "New User"
  end

  test "user can log in" do
    # Create a user first
    user = User.create!(
      name: "Test User",
      email: "testlogin@example.com",
      password: "password",
      password_confirmation: "password"
    )

    visit login_url

    fill_in "email", with: "testlogin@example.com"
    fill_in "password", with: "password"

    click_on "Log In"

    assert_selector ".bg-green-100", text: "Logged in successfully!"
    assert_selector "nav", text: "Test User"
  end

  test "user can log out" do
    # Create and log in a user
    user = User.create!(
      name: "Logout Test",
      email: "logout@example.com",
      password: "password",
      password_confirmation: "password"
    )

    visit login_url
    fill_in "email", with: "logout@example.com"
    fill_in "password", with: "password"
    click_on "Log In"

    # Now log out
    find_by_id("logout-button").click

    # Wait for the page to reload and check for the flash message
    assert_current_path root_path
    assert_selector ".bg-green-100", text: "Logged out successfully!"
    assert_selector "nav", text: "Sign Up"
  end
end
