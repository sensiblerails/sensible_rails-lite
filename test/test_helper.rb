ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Helper for testing authorization
    def log_in_as(user)
      session[:user_id] = user.id
    end
  end
end

# Integration test helpers
module ActionDispatch
  class IntegrationTest
    # Log in as a particular user for controller/integration tests
    def log_in_as(user, password: "password123")
      post login_path, params: { email: user.email, password: password }
    end
  end
end
