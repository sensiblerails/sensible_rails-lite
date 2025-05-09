require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_password_reset_url
    assert_response :success
  end

  test "should create password reset" do
    user = users(:regular)
    post password_resets_url, params: { email: user.email }
    assert_redirected_to root_url
  end

  test "should get edit with token" do
    user = users(:regular)
    # Create a reset token
    token = SecureRandom.urlsafe_base64
    user.update_columns(
      reset_password_token: Digest::SHA256.hexdigest(token),
      reset_password_sent_at: Time.current
    )

    get edit_password_reset_url(Digest::SHA256.hexdigest(token))
    assert_response :success
  end

  test "should update password" do
    user = users(:regular)
    # Create a reset token
    token = SecureRandom.urlsafe_base64
    digest = Digest::SHA256.hexdigest(token)
    user.update_columns(
      reset_password_token: digest,
      reset_password_sent_at: Time.current
    )

    patch password_reset_url(digest), params: {
      user: {
        password: "newpassword",
        password_confirmation: "newpassword"
      }
    }
    assert_redirected_to root_url
  end
end
