class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  before_validation :set_prices
  before_validation :set_product_details
  
  private
  
  def set_prices
    if product.present?
      self.unit_price = product.current_price
      self.total_price = unit_price * quantity
    end
  end
  
  def set_product_details
    if product.present?
      self.product_name = product.name
      self.product_color = product.color
      self.iphone_model = product.iphone_model
    end
  end
end