# =============================================
# APP/MODELS/ADDRESS.RB
# =============================================

class Address < ApplicationRecord
  belongs_to :user
  
  validates :street_address, :city, :province, :postal_code, presence: true
  validates :postal_code, format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/, message: "Invalid Canadian postal code" }
  
  before_save :ensure_single_default
  
  CANADIAN_PROVINCES = [
    ['Alberta', 'AB'], ['British Columbia', 'BC'], ['Manitoba', 'MB'],
    ['New Brunswick', 'NB'], ['Newfoundland and Labrador', 'NL'],
    ['Northwest Territories', 'NT'], ['Nova Scotia', 'NS'], ['Nunavut', 'NU'],
    ['Ontario', 'ON'], ['Prince Edward Island', 'PE'], ['Quebec', 'QC'],
    ['Saskatchewan', 'SK'], ['Yukon', 'YT']
  ].freeze
  
  private
  
  def ensure_single_default
    if is_default?
      user.addresses.where.not(id: id).update_all(is_default: false)
    end
  end
end