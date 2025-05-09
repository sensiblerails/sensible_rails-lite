require "faker"

namespace :db do
  desc "Seed database with Faker data while avoiding SolidQueue issues"
  task faker_seed: :environment do
    # Override any broadcast methods to avoid queue issues
    if defined?(Post)
      Post.class_eval do
        def broadcast_create_later; end
        def broadcast_update_later; end
      end
    end

    puts "Seeding database with Faker data..."

    # Create admin users
    admin1 = User.find_or_create_by(email: "admin1@example.com") do |user|
      user.name = "Admin One"
      user.password = "password123"
      user.password_confirmation = "password123"
      user.admin = true
      puts "Created admin user: admin1@example.com / password123"
    end

    admin2 = User.find_or_create_by(email: "admin2@example.com") do |user|
      user.name = "Admin Two"
      user.password = "password123"
      user.password_confirmation = "password123"
      user.admin = true
      puts "Created admin user: admin2@example.com / password123"
    end

    # Create regular users
    regular_users = []
    15.times do |i|
      email = "user#{i+1}@example.com"
      user = User.find_or_create_by(email: email) do |u|
        u.name = Faker::Name.name
        u.password = "password123"
        u.password_confirmation = "password123"
        puts "Created regular user: #{email} / password123 (#{u.name})"
      end
      regular_users << user
    end

    # Reset and create posts with Faker content
    Post.where("title LIKE ?", "Sample Post%").destroy_all # Remove any previously generated sample posts

    # Create posts
    all_users = regular_users + [ admin1, admin2 ]
    30.times do |i|
      user = all_users.sample
      title = Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 2)

      # Only create if a post with this title doesn't exist for this user
      next if user.posts.exists?(title: title)

      # Use direct INSERT to bypass callbacks
      post = Post.new(
        title: title,
        content: Faker::Lorem.paragraphs(number: rand(2..5)).join("\n\n"),
        user_id: user.id,
        created_at: Time.now,
        updated_at: Time.now
      )

      # Save without callbacks
      if post.save(validate: false)
        puts "Created post: #{post.title} by #{user.name}"
      end
    end

    puts "\nSeeding completed! Created:"
    puts "- #{User.where(admin: true).count} admin users"
    puts "- #{User.where(admin: false).count} regular users"
    puts "- #{Post.count} posts"
  end
end
