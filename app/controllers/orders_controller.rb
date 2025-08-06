# =============================================
# APP/CONTROLLERS/ORDERS_CONTROLLER.RB
# =============================================

class OrdersController < ApplicationController
  before_action :require_login
  before_action :set_order, only: [:show]
  
  def index
    @orders = current_user.orders.recent.includes(:order_items)
                         .page(params[:page]).per(10)
  end
  
  def show
  end
  
  private
  
  def set_order
    @order = current_user.orders.find_by!(order_number: params[:order_number])
  end
end
