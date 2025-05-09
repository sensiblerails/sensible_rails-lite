class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_user
  helper_method :current_user, :logged_in?, :admin?, :impersonating?, :original_user
  helper :policies

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def current_user
    if session[:impersonated_user_id]
      User.find_by(id: session[:impersonated_user_id])
    else
      Current.user
    end
  end

  def original_user
    return unless impersonating?
    User.find_by(id: session[:user_id])
  end

  def impersonating?
    session[:impersonated_user_id].present?
  end

  def logged_in?
    current_user.present?
  end

  def admin?
    Current.user&.admin?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  def require_admin
    unless logged_in? && admin?
      flash[:alert] = "You don't have permission to access this page."
      redirect_to root_path
    end
  end

  def require_correct_user
    @user = User.find(params[:id])
    unless current_user == @user || admin?
      flash[:alert] = "You don't have permission to perform this action."
      redirect_to root_path
    end
  end
end
