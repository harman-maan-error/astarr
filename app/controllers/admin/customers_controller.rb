class Admin::CustomersController < ApplicationController
  before_action :require_login
  before_action :require_admin
  
  def index
    @customers = User.includes(:orders, :addresses)
                    .order(:last_name, :first_name)
    
    # Calculate statistics
    @total_outstanding = Order.where(status: ['pending', 'processing', 'shipped']).count
    @outstanding_value = Order.where(status: ['pending', 'processing', 'shipped'])
                             .sum(:total_amount) || 0
    @customers_with_outstanding = User.joins(:orders)
                                     .where(orders: { status: ['pending', 'processing', 'shipped'] })
                                     .distinct.count
  end
  
  def show
    @customer = User.find(params[:id])
    @orders = @customer.orders.includes(:order_items, :product)
                              .order(created_at: :desc)
    @addresses = @customer.addresses.order(:is_default)
  end
  
  private
  
  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end