require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  # Helper method to log in a user
  def login_as(user)
    visit login_url
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_on "Log In"

    # Wait for the login to complete
    assert_selector "nav", text: user.name
  end

  # Debug helper to print the current page body
  def debug_page
    puts "\n\n========== DEBUG PAGE CONTENT ==========\n\n"
    puts page.body
    puts "\n\n========== END DEBUG PAGE CONTENT ==========\n\n"
  end
end
