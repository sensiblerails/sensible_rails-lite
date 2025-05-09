class PasswordResetsController < ApplicationController
  before_action :get_user, only: [ :edit, :update ]
  before_action :valid_user, only: [ :edit, :update ]
  before_action :check_expiration, only: [ :edit, :update ]

  def new
  end

  def create
    @user = User.find_by(email: params[:email].downcase)

    if @user
      @user.create_reset_digest
      # Simulate sending an email (would use mailer in a real app)
      # Instead, we'll log the reset token for development purposes
      reset_url = edit_password_reset_url(@user.reset_password_token)
      Rails.logger.info "Password reset link for #{@user.email}: #{reset_url}"
      flash[:notice] = "Email sent with password reset instructions. Check console for reset link."
      redirect_to root_path
    else
      flash.now[:alert] = "Email address not found."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit, status: :unprocessable_entity
    elsif @user.update(user_params)
      session[:user_id] = @user.id
      @user.update_columns(reset_password_token: nil, reset_password_sent_at: nil)
      flash[:notice] = "Password has been reset."
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(reset_password_token: params[:id])
  end

  def valid_user
    unless @user && @user.reset_password_sent_at.present?
      flash[:alert] = "Invalid reset token."
      redirect_to root_path
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:alert] = "Password reset link has expired."
      redirect_to new_password_reset_path
    end
  end
end
