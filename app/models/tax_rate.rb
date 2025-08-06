# =============================================
# APP/MODELS/TAX_RATE.RB
# =============================================

class TaxRate < ApplicationRecord
  validates :province, presence: true, uniqueness: true
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1 }
  
  scope :active, -> { where(active: true) }
  
  def self.for_province(province)
    active.find_by(province: province)&.rate || 0.13
  end
end