require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    @regular = users(:regular)
    @admin_post = posts(:admin_post)
    @regular_post = posts(:regular_post)
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new when logged in" do
    log_in_as(@admin)
    get new_post_url
    assert_response :success
  end
  
  test "should redirect new when not logged in" do
    get new_post_url
    assert_redirected_to login_url
  end

  test "should create post when logged in" do
    log_in_as(@admin)
    assert_difference("Post.count") do
      post posts_url, params: { post: { content: "Test content", title: "Test title" } }
    end

    assert_redirected_to post_url(Post.last)
    assert_equal @admin.id, Post.last.user_id
  end

  test "should show post" do
    get post_url(@admin_post)
    assert_response :success
  end

  test "should get edit for own post" do
    log_in_as(@admin)
    get edit_post_url(@admin_post)
    assert_response :success
  end
  
  test "should not get edit for other's post" do
    log_in_as(@regular)
    get edit_post_url(@admin_post)
    assert_redirected_to posts_url
  end

  test "should update own post" do
    log_in_as(@admin)
    patch post_url(@admin_post), params: { post: { content: "Updated content", title: "Updated title" } }
    assert_redirected_to post_url(@admin_post)
    @admin_post.reload
    assert_equal "Updated title", @admin_post.title
  end
  
  test "should not update other's post" do
    log_in_as(@regular)
    original_title = @admin_post.title
    patch post_url(@admin_post), params: { post: { content: "Should not update", title: "Should not update" } }
    assert_redirected_to posts_url
    @admin_post.reload
    assert_equal original_title, @admin_post.title
  end

  test "should destroy own post" do
    log_in_as(@admin)
    assert_difference("Post.count", -1) do
      delete post_url(@admin_post)
    end

    assert_redirected_to posts_url
  end
  
  test "should not destroy other's post" do
    log_in_as(@regular)
    assert_no_difference("Post.count") do
      delete post_url(@admin_post)
    end

    assert_redirected_to posts_url
  end
end
