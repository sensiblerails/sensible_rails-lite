require "application_system_test_case"

class PostsRealtimeTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin)
    @regular = users(:regular)

    # Log in as admin user
    visit login_url
    fill_in "Email", with: @admin.email
    fill_in "Password", with: "password123"
    click_on "Log In"
  end

  test "new posts appear at the top of the page in real-time" do
    # Open posts index in the current window
    visit posts_url

    # Create a unique post title for this test
    test_title = "Real-time Test Post #{Time.current.to_i}"

    # Create a new post programmatically (simulating another user creating a post)
    new_post = Post.create!(
      title: test_title,
      content: "This post should appear at the top of the page in real-time.",
      user: @regular
    )

    # Wait for Turbo Stream to update the page
    assert_selector "h3", text: test_title, wait: 5

    # Verify the new post appears on the page with the correct dom_id
    assert_selector "#post_#{new_post.id}", text: test_title
  end

  test "updated posts reflect changes in real-time" do
    # Create a post to be updated
    post = Post.create!(
      title: "Post to be updated",
      content: "Original content",
      user: @admin
    )

    # Visit the posts index
    visit posts_url

    # Verify the original post is visible with the correct dom_id
    assert_selector "#post_#{post.id}", text: "Post to be updated"

    # Update the post programmatically
    post.update!(title: "Updated Post Title")

    # Wait for Turbo Stream to update the page
    assert_selector "#post_#{post.id}", text: "Updated Post Title", wait: 5

    # Verify the old title is no longer visible
    assert_no_text "Post to be updated"
  end

  test "deleted posts are removed from the page in real-time" do
    # Create a post to be deleted
    post = Post.create!(
      title: "Post to be deleted",
      content: "This post will be deleted",
      user: @admin
    )

    # Visit the posts index
    visit posts_url

    # Verify the post is visible with the correct dom_id
    post_dom_id = "#post_#{post.id}"
    assert_selector post_dom_id, text: "Post to be deleted"

    # Delete the post programmatically
    post.destroy

    # Wait for Turbo Stream to update the page (using a negative assertion with wait)
    assert_no_selector post_dom_id, wait: 5
  end
end
