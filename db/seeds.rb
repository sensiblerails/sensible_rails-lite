# This file creates seed data for the application in an idempotent way.
# It can be run multiple times without creating duplicate data.

puts "Seeding database..."

# Create admin users if they don't exist
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

# Create regular users if they don't exist
regular_users = []
15.times do |i|
  email = "user#{i+1}@example.com"
  user = User.find_or_create_by(email: email) do |u|
    u.name = Faker::Name.name
    u.password = "password123"
    u.password_confirmation = "password123"
    puts "Created regular user: #{email} / password123"
  end
  regular_users << user
end

# Create posts if they don't exist
all_users = regular_users + [ admin1, admin2 ]

30.times do |i|
  user = all_users.sample
  title = Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 2)

  # Only create if a post with this title doesn't exist for this user
  next if user.posts.exists?(title: title)

  post = user.posts.create!(
    title: title,
    content: Faker::Lorem.paragraphs(number: rand(2..5)).join("\n\n")
  )
  puts "Created post: #{post.title} by #{user.name}"
end

puts "Seeding completed! Created:"
puts "- #{User.where(admin: true).count} admin users"
puts "- #{User.where(admin: false).count} regular users"
puts "- #{Post.count} posts"
