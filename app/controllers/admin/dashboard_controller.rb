class Admin::DashboardController < Admin::BaseController
  def index
    @total_products = Product.count
    @total_orders = Order.count
    @total_customers = User.where(is_admin: false).count
    @total_revenue = Order.where(payment_status: 'paid').sum(:total_amount)
  end
end