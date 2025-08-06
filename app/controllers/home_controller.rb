# =============================================
# APP/CONTROLLERS/HOME_CONTROLLER.RB
# =============================================

class HomeController < ApplicationController
  def index
    @featured_products = Product.active.featured.includes(:category, :product_images).limit(8)
    @regular_products = Product.joins(:category)
                              .where(categories: { is_premium: false })
                              .active.limit(4)
    @premium_products = Product.joins(:category)
                              .where(categories: { is_premium: true })
                              .active.limit(4)
    
    @hero_title = SiteContent.get_content('home', 'hero_title')
    @hero_subtitle = SiteContent.get_content('home', 'hero_subtitle')
  end
end