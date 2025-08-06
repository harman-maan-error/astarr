class Page < ApplicationRecord
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-_]+\z/ }
  validates :title, presence: true
  validates :content, presence: true
  
  scope :published, -> { where(published: true) }
  
  def to_param
    slug
  end
  
  def self.find_by_slug(slug)
    find_by(slug: slug)
  end
end
