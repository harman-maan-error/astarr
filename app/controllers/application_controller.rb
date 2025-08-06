# =============================================
# APP/CONTROLLERS/APPLICATION_CONTROLLER.RB
# =============================================

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :current_cart
  
  helper_method :current_user, :logged_in?, :current_cart, :cart_count
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !!current_user
  end
  
  def require_login
    unless logged_in?
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end
  
  def require_admin
    unless logged_in? && current_user.is_admin?
      flash[:alert] = "Access denied. Admin privileges required."
      redirect_to root_path
    end
  end
  
  def current_cart
    @current_cart ||= Cart.new(session[:cart])
  end
  
  def cart_count
    current_cart.total_items
  end
  
  def save_cart
    session[:cart] = current_cart.to_h
  end
end
