# =============================================
# APP/CONTROLLERS/ADDRESSES_CONTROLLER.RB
# =============================================

class AddressesController < ApplicationController
  before_action :require_login
  before_action :set_address, only: [:show, :edit, :update, :destroy, :set_default]
  
  def index
    @addresses = current_user.addresses.order(:is_default)
  end
  
  def new
    @address = current_user.addresses.build
  end
  
  def create
    @address = current_user.addresses.build(address_params)
    
    if @address.save
      flash[:notice] = "Address added successfully."
      redirect_to addresses_path
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @address.update(address_params)
      flash[:notice] = "Address updated successfully."
      redirect_to addresses_path
    else
      render :edit
    end
  end
  
  def destroy
    if @address.is_default? && current_user.addresses.count > 1
      flash[:alert] = "Cannot delete default address. Set another address as default first."
    else
      @address.destroy
      flash[:notice] = "Address deleted successfully."
    end
    redirect_to addresses_path
  end
  
  def set_default
    @address.update(is_default: true)
    flash[:notice] = "Default address updated."
    redirect_to addresses_path
  end
  
  private
  
  def set_address
    @address = current_user.addresses.find(params[:id])
  end
  
  def address_params
    params.require(:address).permit(:street_address, :city, :province, 
                                   :postal_code, :country, :is_default)
  end
end