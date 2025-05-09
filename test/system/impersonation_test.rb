require "application_system_test_case"

class ImpersonationTest < ApplicationSystemTestCase
  setup do
    # Create users if not already in fixtures
    @admin = users(:admin)
    @regular_user = users(:regular)

    # Log in as admin
    visit login_url
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "password123"
    click_on "Log In"
  end

  test "admin can impersonate a user" do
    # Visit users index
    visit users_url

    # Find the impersonate button for the regular user and click it
    within("tr", text: @regular_user.email) do
      click_on "Impersonate"
    end

    # Check for impersonation banner
    assert_selector "div", text: "You are currently impersonating #{@regular_user.name}"

    # Verify we see the site as the regular user
    assert_selector "nav", text: @regular_user.name
  end

  test "admin can stop impersonating a user" do
    # First impersonate a user
    visit users_url
    within("tr", text: @regular_user.email) do
      click_on "Impersonate"
    end

    # Then stop impersonating
    click_on "Stop Impersonating"

    # Verify we're back as admin
    assert_no_selector "div", text: "You are currently impersonating"
    assert_selector "nav", text: @admin.name
  end
end
