namespace :db do
  namespace :fixtures do
    desc "Load fixtures into the production database"
    task load_production: :environment do
      # Temporarily disable database logging
      ActiveRecord::Base.logger = nil
      
      # Get fixtures path
      fixtures_path = Rails.root.join('test', 'fixtures')
      
      # Load fixtures in correct order (users first, then posts)
      puts "Loading fixtures into the production database..."
      
      # Specific order for loading fixtures
      ordered_fixtures = ['users', 'posts']
      
      ordered_fixtures.each do |fixture_name|
        puts "Loading #{fixture_name} fixtures..."
        begin
          ActiveRecord::FixtureSet.create_fixtures(fixtures_path, fixture_name)
          puts "  ✓ #{fixture_name} loaded successfully"
        rescue => e
          puts "  ✗ Error loading #{fixture_name}: #{e.message}"
        end
      end
      
      puts "Fixture loading completed!"
      
      # Output summary
      puts "\nDatabase summary:"
      puts "- Users: #{User.count} (#{User.where(admin: true).count} admins)"
      puts "- Posts: #{Post.count}"
    end
  end
end
