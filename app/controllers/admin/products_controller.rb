class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  
  def index
    @products = Product.all.order(created_at: :desc)
    @total_products = @products.count
  end
  
  def show
    # Product details view
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
   
    # Auto-generate slug if not provided
    if @product.slug.blank? && @product.name.present?
      @product.slug = @product.name.parameterize
    end
   
    if @product.save
      # Handle multiple image uploads
      handle_image_uploads if params[:product][:images].present?
      
      redirect_to "/admin/products", notice: 'Product was successfully created.'
    else
      render :new
    end
  end
  
  def edit
    # Edit form will be rendered
  end
  
  def update
    # Auto-generate slug if not provided
    if params[:product][:slug].blank? && params[:product][:name].present?
      params[:product][:slug] = params[:product][:name].parameterize
    end
   
    # Handle image removal
    if params[:product][:remove_image] == '1'
      primary_image = @product.primary_image
      if primary_image&.image&.attached?
        primary_image.image.purge
        primary_image.destroy
      end
    end
   
    if @product.update(product_params)
      # Handle new image uploads (add to existing images)
      if params[:product][:images].present?
        handle_image_uploads
      end
      
      # Handle single image update (for backward compatibility)
      if params[:product][:image].present?
        handle_single_image_update
      end
     
      redirect_to "/admin/products", notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    product_name = @product.name
    if @product.destroy
      redirect_to "/admin/products", notice: "Product '#{product_name}' was successfully deleted."
    else
      redirect_to "/admin/products", alert: "Failed to delete product."
    end
  end
  
  private
  
  def set_product
    @product = Product.find(params[:id])
  end
  
  def product_params
    params.require(:product).permit(:name, :slug, :base_price, :stock_quantity, 
                                   :iphone_model, :category_id, :description, :specifications,
                                   :active, :color, :material, :is_featured, :is_on_sale, 
                                   :sale_price)
  end
  
  def handle_image_uploads
    # Get the current highest sort_order to continue numbering
    current_max_sort = @product.product_images.maximum(:sort_order) || 0
    
    params[:product][:images].each_with_index do |image, index|
      next if image.blank?
      
      # Determine if this should be primary (first image and no existing primary)
      is_primary = (current_max_sort == 0 && index == 0) || @product.primary_image.nil?
      
      product_image = @product.product_images.build(
        is_primary: is_primary,
        sort_order: current_max_sort + index + 1,
        alt_text: @product.name
      )
      
      product_image.image.attach(image)
      product_image.save!
    end
  end
  
  # For backward compatibility with single image uploads
  def handle_single_image_update
    primary_image = @product.primary_image
   
    if primary_image
      # Replace existing image
      primary_image.image.purge if primary_image.image.attached?
      primary_image.image.attach(params[:product][:image])
    else
      # Create new primary image
      product_image = @product.product_images.create(
        is_primary: true,
        sort_order: 1,
        alt_text: @product.name
      )
      product_image.image.attach(params[:product][:image])
    end
  end
end