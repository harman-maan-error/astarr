# =============================================
# APP/MODELS/REVIEW.RB
# =============================================

class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :title, presence: true
  validates :comment, presence: true, length: { minimum: 10 }
  validates :user_id, uniqueness: { scope: :product_id, message: "can only review a product once" }
  
  after_create :update_product_reviews_count
  after_destroy :update_product_reviews_count
  
  scope :approved, -> { where(approved: true) }
  scope :by_rating, ->(rating) { where(rating: rating) }
  
  private
  
  def update_product_reviews_count
    product.update_column(:reviews_count, product.reviews.approved.count)
  end
end