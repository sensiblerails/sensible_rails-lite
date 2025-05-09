class Post < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :content, presence: true

  broadcasts_to ->(post) { "posts" }, inserts_by: :prepend
end
