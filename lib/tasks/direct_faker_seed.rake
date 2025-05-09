require 'faker'
require 'bcrypt'

namespace :db do
  desc "Directly seed database with Faker data using SQL to bypass all callbacks"
  task direct_faker_seed: :environment do
    puts "Seeding database directly with Faker data..."
    
    # Create admin users if they don't exist
    connection = ActiveRecord::Base.connection
    
    # Helper method to generate bcrypt password
    def bcrypt_password(password)
      BCrypt::Password.create(password)
    end
    
    puts "Creating admin users..."
    # Admin users
    admin_users = [
      { email: "admin1@example.com", name: "Admin One" },
      { email: "admin2@example.com", name: "Admin Two" }
    ]
    
    admin_users.each do |admin|
      result = connection.execute("SELECT id FROM users WHERE email = '#{admin[:email]}'")
      if result.ntuples == 0
        connection.execute(
          "INSERT INTO users (name, email, password_digest, admin, created_at, updated_at) VALUES " +
          "('#{admin[:name]}', '#{admin[:email]}', '#{bcrypt_password('password123')}', true, NOW(), NOW())"
        )
        puts "Created admin user: #{admin[:email]} / password123"
      else
        puts "Admin user exists: #{admin[:email]}"
      end
    end
    
    puts "Creating regular users..."
    # Regular users
    15.times do |i|
      email = "user#{i+1}@example.com"
      name = Faker::Name.name.gsub("'", "''") # Escape single quotes for SQL
      
      result = connection.execute("SELECT id FROM users WHERE email = '#{email}'")
      if result.ntuples == 0
        connection.execute(
          "INSERT INTO users (name, email, password_digest, admin, created_at, updated_at) VALUES " +
          "('#{name}', '#{email}', '#{bcrypt_password('password123')}', false, NOW(), NOW())"
        )
        puts "Created regular user: #{email} / password123 (#{name})"
      else
        puts "Regular user exists: #{email}"
      end
    end
    
    # Fetch all user IDs
    user_ids = connection.execute("SELECT id FROM users").to_a.map { |row| row['id'] }
    
    puts "Creating posts..."
    # Create posts with Faker content
    30.times do |i|
      user_id = user_ids.sample
      title = Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 2).gsub("'", "''")
      content = Faker::Lorem.paragraphs(number: rand(2..5)).join("\n\n").gsub("'", "''")
      
      connection.execute(
        "INSERT INTO posts (title, content, user_id, created_at, updated_at) VALUES " +
        "('#{title}', '#{content}', #{user_id}, NOW(), NOW())"
      )
      puts "Created post: #{title}"
    end
    
    # Count records
    admin_count = connection.execute("SELECT COUNT(*) FROM users WHERE admin = true").to_a[0]['count']
    user_count = connection.execute("SELECT COUNT(*) FROM users WHERE admin = false").to_a[0]['count']
    post_count = connection.execute("SELECT COUNT(*) FROM posts").to_a[0]['count']
    
    puts "\nSeeding completed! Created:"
    puts "- #{admin_count} admin users"
    puts "- #{user_count} regular users"
    puts "- #{post_count} posts"
  end
end
