class ProductsController < ApplicationController
  before_action :set_product, only: [:show]
  
  def index
    @products = Product.active.includes(:category, :product_images)
    
    if params[:category].present?
      @products = @products.by_category(params[:category])
      @current_category = Category.find_by(slug: params[:category])
    end
    
    if params[:iphone_model].present?
      @products = @products.by_iphone_model(params[:iphone_model])
    end
    
    case params[:filter]
    when 'featured'
      @products = @products.featured
    when 'on_sale'
      @products = @products.on_sale
    when 'new'
      @products = @products.where('created_at > ?', 1.week.ago)
    end
    
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @products = @products.where(
        "LOWER(name) LIKE ? OR LOWER(description) LIKE ? OR LOWER(iphone_model) LIKE ?",
        search_term, search_term, search_term
      )
    end
    
    case params[:sort]
    when 'price_low'
      @products = @products.order(:base_price)
    when 'price_high'
      @products = @products.order(base_price: :desc)
    when 'rating'
      @products = @products.order(average_rating: :desc)
    when 'newest'
      @products = @products.order(created_at: :desc)
    else
      @products = @products.order(:name)
    end
    
    @products = @products.page(params[:page]).per(12) if respond_to?(:page)
    
    @categories = Category.all
    @iphone_models = Product::IPHONE_MODELS
  end
  
  def show
    @related_products = Product.active
                              .where(iphone_model: @product.iphone_model)
                              .where.not(id: @product.id)
                              .limit(4)
    @reviews = @product.reviews.approved.includes(:user).order(created_at: :desc)
  end
  
  private
  
  def set_product
    @product = Product.active.find_by!(slug: params[:id])
  end
end