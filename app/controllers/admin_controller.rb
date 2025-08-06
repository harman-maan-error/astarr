class AdminController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'
  
  private
  
  def authenticate_admin!
    # Basic authentication - replace with your admin auth system
    unless current_user&.admin? || Rails.env.development?
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end