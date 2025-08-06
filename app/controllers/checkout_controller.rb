# =============================================
# APP/CONTROLLERS/CHECKOUT_CONTROLLER.RB
# =============================================

class CheckoutController < ApplicationController
  before_action :require_login
  before_action :ensure_cart_not_empty
  
  def show
    @cart_products = current_cart.products.includes(:category)
    @cart_items = current_cart.items
    @addresses = current_user.addresses.order(:is_default)
    @subtotal = current_cart.subtotal
    
    shipping_address = @addresses.find_by(is_default: true) || @addresses.first
    @tax_rate = shipping_address ? TaxRate.for_province(shipping_address.province) : 0.13
    @tax_amount = @subtotal * @tax_rate
    @total = @subtotal + @tax_amount
  end
  
  def create
    ActiveRecord::Base.transaction do
      @order = build_order
      
      if @order.save
        create_order_items
        current_cart.clear
        save_cart
        flash[:notice] = "Order placed successfully! Order number: #{@order.order_number}"
        redirect_to order_path(@order.order_number)
      else
        flash[:alert] = "There was an error processing your order."
        redirect_to checkout_path
      end
    end
  rescue => e
    flash[:alert] = "There was an error processing your order: #{e.message}"
    redirect_to checkout_path
  end
  
  private
  
  def build_order
    shipping_address = current_user.addresses.find(params[:shipping_address_id])
    tax_rate = TaxRate.for_province(shipping_address.province)
    subtotal = current_cart.subtotal
    tax_amount = subtotal * tax_rate
    
    Order.new(
      user: current_user,
      subtotal: subtotal,
      tax_rate: tax_rate,
      tax_amount: tax_amount,
      total_amount: subtotal + tax_amount,
      billing_street_address: shipping_address.street_address,
      billing_city: shipping_address.city,
      billing_province: shipping_address.province,
      billing_postal_code: shipping_address.postal_code,
      billing_country: shipping_address.country,
      shipping_street_address: shipping_address.street_address,
      shipping_city: shipping_address.city,
      shipping_province: shipping_address.province,
      shipping_postal_code: shipping_address.postal_code,
      shipping_country: shipping_address.country,
      status: 'confirmed',
      payment_status: 'paid'
    )
  end
  
  def create_order_items
    current_cart.products.each do |product|
      quantity = current_cart.items[product.id.to_s]
      @order.order_items.create!(
        product: product,
        quantity: quantity,
        unit_price: product.current_price,
        total_price: product.current_price * quantity,
        product_name: product.name,
        product_color: product.color,
        iphone_model: product.iphone_model
      )
    end
  end
  
  def ensure_cart_not_empty
    if current_cart.empty?
      flash[:alert] = "Your cart is empty."
      redirect_to products_path
    end
  end
end
