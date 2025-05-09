class WelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user
    
    # In a real application, this would send an email
    # For this example, we'll just log a message
    Rails.logger.info "Welcome email sent to #{user.email}!"
  end
end
