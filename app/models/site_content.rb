# =============================================
# APP/MODELS/SITE_CONTENT.RB
# =============================================

class SiteContent < ApplicationRecord
  validates :page_name, :section, presence: true
  validates :section, uniqueness: { scope: :page_name }
  
  scope :active, -> { where(active: true) }
  scope :for_page, ->(page) { where(page_name: page) }
  
  def self.get_content(page, section)
    active.find_by(page_name: page, section: section)&.content || ''
  end
end