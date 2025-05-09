# AGENT.md for Sensible Rails Lite

## Build & Run Commands
- Setup: `bin/setup`
- Run server: `bin/rails server` or `bin/dev` (with TailwindCSS)
- Run console: `bin/rails console`
- Database setup: `bin/rails db:prepare`
- Run all tests: `bin/rails test`
- Run single test: `bin/rails test TEST=test/path/to/file_test.rb`
- Run specific test: `bin/rails test TEST=test/path/to/file_test.rb:LINE_NUMBER`
- Run system tests: `bin/rails test:system`
- Lint: `bundle exec rubocop`
- Check security: `bundle exec brakeman`

## Code Style Guidelines
- Follow Rails Omakase style guide (rubocop-rails-omakase)
- Use 2 spaces for indentation
- Use snake_case for methods and variables
- Use CamelCase for classes and modules
- RESTful controllers with standard CRUD actions
- Prefer service objects for complex business logic
- Use Active Record validations and callbacks appropriately
- Write comprehensive tests for all functionality