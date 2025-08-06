class CartController < ApplicationController
  before_action :set_product, only: [:add_item]
  
  def show
    if current_cart.empty?
      @cart_products = []
      @cart_items = {}
    else
      # Get products by IDs and include associations
      product_ids = current_cart.items.keys
      @cart_products = Product.where(id: product_ids).includes(:category, :product_images)
      @cart_items = current_cart.items
    end
  end
  
  def add_item
    if @product.in_stock?
      current_cart.add_item(@product.id, params[:quantity].to_i)
      save_cart
      flash[:notice] = "#{@product.name} added to cart!"
    else
      flash[:alert] = "Sorry, this item is out of stock."
    end
    
    redirect_back(fallback_location: @product)
  end
  
  def update_item
    current_cart.update_quantity(params[:product_id], params[:quantity].to_i)
    save_cart
    
    respond_to do |format|
      format.html { redirect_to cart_path }
      format.json { render json: { status: 'success', total_items: cart_count } }
    end
  end
  
  def remove_item
    current_cart.remove_item(params[:product_id])
    save_cart
    flash[:notice] = "Item removed from cart."
    redirect_to cart_path
  end
  
  def clear
    current_cart.clear
    save_cart
    flash[:notice] = "Cart cleared."
    redirect_to cart_path
  end
  
  private
  
  def set_product
    # Find product by slug (since that's what we're using in URLs)
    @product = Product.find_by!(slug: params[:product_id])
  end
end