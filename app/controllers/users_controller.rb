class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update]
 
  def new
    redirect_to root_path if logged_in?
    @user = User.new
    @user.addresses.build  # Build an empty address for the form
  end
 
  def create
    @user = User.new(user_params)
   
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Account created successfully! Welcome to Astarr!"
      redirect_to root_path
    else
      # If validation fails, rebuild the address for the form
      @user.addresses.build if @user.addresses.empty?
      render :new
    end
  end
 
  def show
    @orders = @user.orders.recent.limit(5)
    @addresses = @user.addresses.order(:is_default)
  end
 
  def edit
  end
 
  def update
    if @user.update(user_params)
      flash[:notice] = "Profile updated successfully."
      redirect_to @user
    else
      render :edit
    end
  end
 
  private
 
  def set_user
    @user = current_user
  end
 
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :first_name, :last_name, :phone,
                                 addresses_attributes: [:street_address, :city, 
                                                       :province, :postal_code, :country, :is_default])
  end
end