-- Insert admin users
INSERT INTO users (name, email, encrypted_password, admin, created_at, updated_at)
VALUES 
  ('Admin One', 'admin1@example.com', '$2a$12$eOXVfXQZBXq3eDo9XcoXxOrHLXCQPFvUQI/YBL0uDLvP3J8BfPCyu', true, NOW(), NOW()),
  ('Admin Two', 'admin2@example.com', '$2a$12$eOXVfXQZBXq3eDo9XcoXxOrHLXCQPFvUQI/YBL0uDLvP3J8BfPCyu', true, NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Insert regular users
INSERT INTO users (name, email, encrypted_password, admin, created_at, updated_at)
VALUES 
  ('User One', 'user1@example.com', '$2a$12$eOXVfXQZBXq3eDo9XcoXxOrHLXCQPFvUQI/YBL0uDLvP3J8BfPCyu', false, NOW(), NOW()),
  ('User Two', 'user2@example.com', '$2a$12$eOXVfXQZBXq3eDo9XcoXxOrHLXCQPFvUQI/YBL0uDLvP3J8BfPCyu', false, NOW(), NOW()),
  ('User Three', 'user3@example.com', '$2a$12$eOXVfXQZBXq3eDo9XcoXxOrHLXCQPFvUQI/YBL0uDLvP3J8BfPCyu', false, NOW(), NOW()),
  ('User Four', 'user4@example.com', '$2a$12$eOXVfXQZBXq3eDo9XcoXxOrHLXCQPFvUQI/YBL0uDLvP3J8BfPCyu', false, NOW(), NOW()),
  ('User Five', 'user5@example.com', '$2a$12$eOXVfXQZBXq3eDo9XcoXxOrHLXCQPFvUQI/YBL0uDLvP3J8BfPCyu', false, NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Insert sample posts
INSERT INTO posts (title, content, user_id, created_at, updated_at)
SELECT 
  'Sample Post ' || generate_series(1, 5),
  'This is the content for sample post ' || generate_series(1, 5) || '. This content was added directly through SQL.',
  u.id,
  NOW(),
  NOW()
FROM users u
WHERE u.email = 'admin1@example.com'
LIMIT 1;

INSERT INTO posts (title, content, user_id, created_at, updated_at)
SELECT 
  'User Post ' || generate_series(1, 5),
  'This is the content for a user post ' || generate_series(1, 5) || '. Created via direct SQL insertion.',
  u.id,
  NOW(),
  NOW()
FROM users u
WHERE u.email = 'user1@example.com'
LIMIT 1;
