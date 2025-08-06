class Admin::PagesController < AdminController
  before_action :set_page, only: [:show, :edit, :update]
  
  def index
    @pages = Page.all.order(:slug)
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @page.update(page_params)
      redirect_to admin_pages_path, notice: "#{@page.title} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private
  
  def set_page
    @page = Page.find_by!(slug: params[:id])
  end
  
  def page_params
    params.require(:page).permit(:title, :content, :meta_description, :meta_keywords, :published)
  end
end