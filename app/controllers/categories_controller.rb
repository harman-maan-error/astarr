# =============================================
# APP/CONTROLLERS/CATEGORIES_CONTROLLER.RB
# =============================================

class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(slug: params[:id])
    @products = @category.products.active.includes(:product_images)
                        .page(params[:page]).per(12)
    
    if params[:iphone_model].present?
      @products = @products.by_iphone_model(params[:iphone_model])
    end
    
    @iphone_models = Product::IPHONE_MODELS
  end
end
