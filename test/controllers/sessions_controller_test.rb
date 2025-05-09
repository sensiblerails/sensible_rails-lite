require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should create session" do
    user = users(:regular)
    post login_url, params: { email: user.email, password: 'password123' }
    assert_redirected_to root_url
    assert session[:user_id].present?
  end

  test "should destroy session" do
    # First log in
    user = users(:regular)
    post login_url, params: { email: user.email, password: 'password123' }
    
    # Then log out
    delete logout_url
    assert_redirected_to root_url
    assert_nil session[:user_id]
  end
end
