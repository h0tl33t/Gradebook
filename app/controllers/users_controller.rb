class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only: [:index]
  before_action :correct_user, only: [:show, :edit, :update]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
    @enable_type_select = true
  end

  def edit
    @enable_type_select = false #Should not be able to change type since the User has already been created with a User subclass.
  end

  def create
    if params[:user] && params[:user][:type]
      @user = params[:user][:type].constantize.new(user_params)
    else
      @user = User.new(user_params)
    end
    
    if @user && @user.save
      sign_in @user
      redirect_to user_path(@user), notice: 'User was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @user.destroy
    sign_out
    redirect_to root_path
  end

  private
    def set_user
      begin
        @user = User.find(params[:id])
      rescue
        redirect_to root_path, notice: 'User profile could not be found.'
      end 
    end
    
    def admin_only
      unless current_user.admin?
        redirect_to root_path, :notice => 'You are not authorized to view that page.'
      end
    end
    
    def correct_user
      unless current_user == @user or current_user.admin?
        redirect_to root_path, :notice => 'You are not authorized to view that page.'
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :type)
      #Allowing :type for sample app to simplify testing.  
      #Would want to remove :type and handle User type assignment at the admin level only.
    end
end
