class Cart
  attr_reader :items
  
  def initialize(session_cart = {})
    @items = session_cart || {}
  end
  
  def add_item(product_id, quantity = 1)
    product_id = product_id.to_s
    @items[product_id] = (@items[product_id] || 0) + quantity
  end
  
  def remove_item(product_id)
    @items.delete(product_id.to_s)
  end
  
  def update_quantity(product_id, quantity)
    if quantity > 0
      @items[product_id.to_s] = quantity
    else
      remove_item(product_id)
    end
  end
  
  def total_items
    @items.values.sum
  end
  
  def empty?
    @items.empty?
  end
  
  def clear
    @items.clear
  end
  
  def product_ids
    @items.keys
  end
  
  def subtotal
    return 0 if empty?
    
    products = Product.where(id: product_ids)
    products.sum { |product| product.current_price * @items[product.id.to_s] }
  end
  
  def to_h
    @items
  end
end