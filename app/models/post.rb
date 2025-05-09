class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  # Fix broadcasting to ensure it works with SolidCable
  after_create_commit -> { broadcast_prepend_to "posts", target: "posts", partial: "posts/post", locals: { post: self } }
  after_update_commit -> { broadcast_replace_to "posts", target: "post_#{id}", partial: "posts/post", locals: { post: self } }
  after_destroy_commit -> { broadcast_remove_to "posts", target: "post_#{id}" }
end
