# =============================================
# APP/CONTROLLERS/REVIEWS_CONTROLLER.RB
# =============================================

class ReviewsController < ApplicationController
  before_action :require_login
  before_action :set_product
  before_action :check_existing_review, only: [:new, :create]
  
  def new
    @review = @product.reviews.build
  end
  
  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user
    
    if @review.save
      flash[:notice] = "Thank you for your review! It will be visible after approval."
      redirect_to @product
    else
      render :new
    end
  end
  
  private
  
  def set_product
    @product = Product.find_by!(slug: params[:product_id])
  end
  
  def check_existing_review
    if @product.reviews.exists?(user: current_user)
      flash[:alert] = "You have already reviewed this product."
      redirect_to @product
    end
  end
  
  def review_params
    params.require(:review).permit(:rating, :title, :comment)
  end
end