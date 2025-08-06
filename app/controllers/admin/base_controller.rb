# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  
  layout 'admin'
  
  protected
  
  def ensure_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'Access denied. Admin privileges required.'
    end
  end
  
  def authenticate_user!
    unless user_signed_in?
      redirect_to new_user_session_path, alert: 'Please sign in to continue.'
    end
  end
  
  def current_user
    # Assuming you have a User model with sessions
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def user_signed_in?
    current_user.present?
  end
  
  # Helper method to check if current user is admin
  def admin_user?
    current_user&.admin? || current_user&.is_admin?
  end
  
  # Set common instance variables for admin views
  def set_admin_breadcrumbs
    @breadcrumbs = [
      { name: 'Admin', path: admin_root_path }
    ]
  end
  
  private
  
  # Override this method if you're using a different admin check
  def admin_required
    ensure_admin!
  end
end