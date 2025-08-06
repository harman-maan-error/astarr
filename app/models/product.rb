class Product < ApplicationRecord
  belongs_to :category
  has_many :product_images, -> { order(:sort_order) }, dependent: :destroy
  has_many :reviews, -> { where(approved: true) }, dependent: :destroy
  has_many :order_items, dependent: :destroy
  
  #validates :name, presence: true
  #validates :slug, presence: true, uniqueness: true
  #validates :base_price, presence: true, numericality: { greater_than: 0 }
  #validates :iphone_model, presence: true
  #validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  
  
  after_update :update_rating, if: :saved_change_to_reviews_count?
  
  scope :active, -> { where(active: true) }
  scope :featured, -> { where(is_featured: true) }
  scope :on_sale, -> { where(is_on_sale: true) }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :by_iphone_model, ->(model) { where(iphone_model: model) }
  scope :by_category, ->(category) { joins(:category).where(categories: { slug: category }) }
  
  IPHONE_MODELS = [
    'iPhone 15 Pro Max', 'iPhone 15 Pro', 'iPhone 15 Plus', 'iPhone 15',
    'iPhone 14 Pro Max', 'iPhone 14 Pro', 'iPhone 14 Plus', 'iPhone 14',
    'iPhone 13 Pro Max', 'iPhone 13 Pro', 'iPhone 13', 'iPhone 13 mini',
    'iPhone 12 Pro Max', 'iPhone 12 Pro', 'iPhone 12', 'iPhone 12 mini'
  ].freeze
  
  def current_price
    is_on_sale? && sale_price.present? ? sale_price : calculated_price
  end
  
  def calculated_price
    base_price * category.price_multiplier
  end
  
  def primary_image
    product_images.find_by(is_primary: true) || product_images.first
  end
  
  def in_stock?
    stock_quantity > 0
  end
  
  def to_param
    slug
  end
  
  private
  
  def generate_slug
    self.slug = "#{name}-#{iphone_model}".parameterize if name.present? && iphone_model.present?
  end
  
  def update_rating
    avg_rating = reviews.average(:rating) || 0.0
    update_column(:average_rating, avg_rating.round(1))
  end
end