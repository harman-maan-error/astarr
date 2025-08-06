class SearchController < ApplicationController
  def index
    @query = params[:q]
    @products = []
    
    if @query.present?
      search_term = "%#{@query.downcase}%"
      @products = Product.active.includes(:category, :product_images)
                         .where(
                           "LOWER(name) LIKE ? OR LOWER(description) LIKE ? OR LOWER(iphone_model) LIKE ? OR LOWER(color) LIKE ?",
                           search_term, search_term, search_term, search_term
                         )
      
      if params[:category].present?
        @products = @products.by_category(params[:category])
      end
      
      # Limit results to prevent too many items on one page
      @products = @products.limit(20)
    end
    
    @categories = Category.all
  end
end