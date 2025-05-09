# Sensible Rails Lite

A lean, modern template for experimenting with core Rails concepts and the latest built-in Rails technologies. This application emphasizes vanilla Rails solutions over external gems, providing a solid foundation for trying out new features and patterns.

## Features

- **Vanilla Rails Authentication** - Built using `has_secure_password` without any external gems
- **User Impersonation** - Admins can impersonate regular users to see the site from their perspective
- **Simple Authorization** - Plain Ruby objects for authorization policies
- **Modern Stack** - Leverages SolidCache, SolidQueue, and SolidCable
- **Hotwire Integration** - Uses Turbo and Stimulus for a modern, reactive frontend
- **Real-time Features** - WebSockets support for instant notifications
- **TailwindCSS** - Clean, responsive styling

## Prerequisites

- Ruby 3.4.1
- Rails 8.0.2
- PostgreSQL
- Node.js (for Tailwind CSS processing)

## Setup Instructions

### 1. Clone the repository

```bash
git clone [repository-url]
cd sensible_rails-lite
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Database setup

Make sure PostgreSQL is running, then set up the database:

```bash
rails db:create db:migrate

# Install and migrate SolidCache, SolidQueue, and SolidCable schemas
rails solid_cache:install solid_queue:install solid_cable:install
rails db:migrate SCOPE=queue
rails db:migrate SCOPE=cache
rails db:migrate SCOPE=cache

# Seed the database with sample data
rails db:seed
```

### 4. Start the server

```bash
bin/dev
```

This will start the Rails server, Tailwind CSS compiler, and any background job processors.

## Demo Credentials

Two admin users are created during seeding:

- **Admin One**
  - Email: admin1@example.com
  - Password: password123

- **Admin Two**
  - Email: admin2@example.com
  - Password: password123

Additionally, 15 regular users are created with emails following the pattern `user1@example.com` through `user15@example.com`, all with the password `password123`.

## Codebase Overview

### Authentication

Authentication is implemented with Rails' built-in `has_secure_password` functionality:

- **User Model**: `app/models/user.rb`
- **Sessions Controller**: `app/controllers/sessions_controller.rb`
- **Users Controller**: `app/controllers/users_controller.rb`
- **Password Resets**: `app/controllers/password_resets_controller.rb`

### User Impersonation

Impersonation is handled in the Users Controller and stored in the session:

- Impersonation logic: `app/controllers/users_controller.rb`
- Current user determination: `app/controllers/application_controller.rb`

### Authorization

The application uses simple PORO policy objects:

- Base policy helpers: `app/helpers/policies_helper.rb`
- Post policy: `app/policies/post_policy.rb`
- Controller authorization: `app/controllers/application_controller.rb`

### Solid Components

- **SolidCache**: Used as the primary Rails cache store
- **SolidQueue**: Configured as the Active Job backend
- **SolidCable**: Set up as the Action Cable backend

### Hotwire

- Turbo Drive is enabled application-wide
- Turbo Streams are used for post updates
- Stimulus controllers: `app/javascript/controllers/`

## Test Suite

Run the tests with:

```bash
rails test
```

The application includes model tests, controller tests, and system tests.

## License

This project is available as open source under the terms of the MIT License.