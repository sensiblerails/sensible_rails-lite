class UsersController < ApplicationController
  before_action :require_login, only: [:index, :show, :edit, :update]
  before_action :require_admin, only: [:index, :impersonate]
  before_action :require_correct_user, only: [:edit, :update]
  
  def index
    @users = User.where(admin: false).order(:name)
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      # We'll just log the welcome message instead of using a job
      Rails.logger.info("Welcome email would be sent to #{@user.email}")
      flash[:notice] = "Welcome to Sensible Rails Lite!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:notice] = "Profile updated successfully."
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def impersonate
    user = User.find(params[:id])
    
    if user.admin?
      flash[:alert] = "Cannot impersonate other admin users."
    else
      session[:impersonated_user_id] = user.id
      flash[:notice] = "You are now impersonating #{user.name}."
    end
    
    redirect_to root_path
  end
  
  def stop_impersonating
    session.delete(:impersonated_user_id)
    flash[:notice] = "You are no longer impersonating another user."
    redirect_to users_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
