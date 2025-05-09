class HomeController < ApplicationController
  def index
    @posts = Post.includes(:user).order(created_at: :desc).limit(5)
  end
end
