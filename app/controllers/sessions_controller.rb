class SessionsController < ApplicationController
  def new
    # Don't allow already logged in users to login again
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully!"
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:impersonated_user_id)
    flash[:notice] = "Logged out successfully!"
    redirect_to root_path
  end
end
