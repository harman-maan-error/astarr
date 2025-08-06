# =============================================
# APP/CONTROLLERS/SESSIONS_CONTROLLER.RB
# =============================================

class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end
  
  def create
    user = User.find_by(email: params[:email]&.downcase)
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      user.update(last_login: Time.current)
      flash[:notice] = "Welcome back, #{user.first_name}!"
      redirect_to session.delete(:return_to) || root_path
    else
      flash.now[:alert] = "Invalid email or password."
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end
end
