require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should save valid user" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
    assert user.save
  end
  
  test "should not save user without name" do
    user = User.new(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.save
  end
  
  test "should not save user without email" do
    user = User.new(
      name: "Test User",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.save
  end
  
  test "should not save user with invalid email" do
    user = User.new(
      name: "Test User",
      email: "invalid",
      password: "password",
      password_confirmation: "password"
    )
    assert_not user.save
  end
  
  test "should not save user with duplicate email" do
    user1 = User.create(
      name: "Test User 1",
      email: "duplicate@example.com",
      password: "password",
      password_confirmation: "password"
    )
    
    user2 = User.new(
      name: "Test User 2",
      email: "duplicate@example.com",
      password: "password",
      password_confirmation: "password"
    )
    
    assert_not user2.save
  end
  
  test "should downcase email before save" do
    user = User.create(
      name: "Test User",
      email: "MixedCase@Example.COM",
      password: "password",
      password_confirmation: "password"
    )
    
    assert_equal "mixedcase@example.com", user.email
  end
end
