require "application_system_test_case"

class AuthenticationTest < ApplicationSystemTestCase
  test "user can sign up" do
    visit signup_url
    
    fill_in "Name", with: "New User"
    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    
    click_on "Sign Up"
    
    assert_text "Welcome to Sensible Rails Lite!"
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
    
    fill_in "Email", with: "testlogin@example.com"
    fill_in "Password", with: "password"
    
    click_on "Log In"
    
    assert_text "Logged in successfully!"
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
    fill_in "Email", with: "logout@example.com"
    fill_in "Password", with: "password"
    click_on "Log In"
    
    # Now log out
    click_on "Logout"
    
    assert_text "Logged out successfully!"
    assert_selector "nav", text: "Sign Up"
  end
end