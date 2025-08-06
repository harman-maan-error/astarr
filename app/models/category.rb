class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :price_multiplier, presence: true, numericality: { greater_than: 0 }
  
  before_validation :generate_slug
  
  scope :premium, -> { where(is_premium: true) }
  scope :regular, -> { where(is_premium: false) }
  
  def to_param
    slug
  end
  
  private
  
  def generate_slug
    self.slug = name.parameterize if name.present?
  end
end