# app/models/product_image.rb
class ProductImage < ApplicationRecord
  belongs_to :product
  has_one_attached :image
  
  validates :sort_order, presence: true, numericality: { greater_than: 0 }
  
  scope :ordered, -> { order(:sort_order) }
  scope :primary, -> { where(is_primary: true) }
  
  # Optional: Add image variants for different sizes
  def thumbnail
    image.variant(resize_to_limit: [150, 150])
  end
  
  def medium
    image.variant(resize_to_limit: [400, 400])
  end
end