require "test_helper"

class WelcomeEmailJobTest < ActiveJob::TestCase
  test "logs welcome message for existing user" do
    user = users(:regular)
    
    # Capture logs during job execution
    output = capture_log_output do
      WelcomeEmailJob.perform_now(user.id)
    end
    
    # Verify the log contains our welcome message
    assert_match /Welcome email sent to #{user.email}/, output
  end
  
  test "does nothing for non-existent user" do
    # Non-existent user ID
    non_existent_id = 999999
    
    # Should not raise an error
    assert_nothing_raised do
      WelcomeEmailJob.perform_now(non_existent_id)
    end
  end
  
  private
  
  def capture_log_output
    original_logger = Rails.logger
    log_output = StringIO.new
    Rails.logger = Logger.new(log_output)
    yield
    log_output.string
  ensure
    Rails.logger = original_logger
  end
end
