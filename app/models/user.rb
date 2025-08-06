class User < ApplicationRecord
  has_secure_password
 
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  
  # Accept nested attributes for addresses
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true
 
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
 
  def full_name
    "#{first_name} #{last_name}".strip
  end
  
  def admin?
    self.is_admin == true rescue false
  end
 
  def default_address
    addresses.find_by(is_default: true) || addresses.first
  end
end