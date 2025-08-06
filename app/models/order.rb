# =============================================
# APP/MODELS/ORDER.RB
# =============================================

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  
  validates :order_number, presence: true, uniqueness: true
  validates :subtotal, :tax_amount, :tax_rate, :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[pending confirmed processing shipped delivered cancelled] }
  validates :payment_status, inclusion: { in: %w[pending paid failed refunded] }
  
  before_validation :generate_order_number, on: :create
  before_validation :calculate_totals
  
  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }
  
  def can_be_cancelled?
    %w[pending confirmed].include?(status)
  end
  
  def items_count
    order_items.sum(:quantity)
  end
  
  def to_param
    order_number
  end
  
  private
  
  def generate_order_number
    self.order_number = "AST#{Time.current.strftime('%Y%m%d')}#{SecureRandom.hex(4).upcase}"
  end
  
  def calculate_totals
    self.subtotal = order_items.sum(&:total_price) if order_items.any?
    self.total_amount = (subtotal || 0) + (tax_amount || 0) + (shipping_cost || 0)
  end
end