class PagesController < ApplicationController
  before_action :set_page
  
  def show
  end
  
  private
  
  def set_page
    @page = Page.published.find_by(slug: params[:slug])
    if @page.nil?
      render file: "#{Rails.root}/public/404", layout: false, status: :not_found
    end
  end
end
