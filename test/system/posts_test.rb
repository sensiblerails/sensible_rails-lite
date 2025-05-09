require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:admin_post)
    @user = users(:admin)
    
    # Log in as admin user
    visit login_url
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password123"
    click_on "Log In"
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "All Posts"
  end

  test "should create post" do
    visit posts_url
    click_on "New Post"

    fill_in "Title", with: "New Test Post"
    fill_in "Content", with: "This is a test post created during system testing."
    click_on "Create Post"

    assert_text "Post was successfully created"
  end

  test "should update Post" do
    visit post_url(@post)
    click_on "Edit Post"

    fill_in "Title", with: "Updated Post Title"
    click_on "Update Post"

    assert_text "Post was successfully updated"
    assert_text "Updated Post Title"
  end

  test "should destroy Post" do
    visit post_url(@post)
    accept_confirm { click_on "Delete Post" }

    assert_text "Post was successfully destroyed"
  end
  
  test "users can only edit their own posts" do
    # Create a post as admin
    visit new_post_url
    fill_in "Title", with: "Admin's Post"
    fill_in "Content", with: "This post belongs to the admin."
    click_on "Create Post"
    
    # Log out
    click_on "Logout"
    
    # Log in as regular user
    visit login_url
    fill_in "Email", with: users(:regular).email
    fill_in "Password", with: "password123"
    click_on "Log In"
    
    # Try to visit the edit page for admin's post
    visit posts_url
    click_on "Admin's Post"
    
    # Edit link should not be visible
    assert_no_selector "a", text: "Edit Post"
  end
end
