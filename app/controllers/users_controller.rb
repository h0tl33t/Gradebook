class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only: [:index]
  before_action :correct_user, only: [:show, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @enable_type_select = true
    #@types = User.types.map(&:to_s)
  end

  # GET /users/1/edit
  def edit
    @enable_type_select = false #Should not be able to change type since the User has already been created with a User subclass.
  end

  # POST /users
  # POST /users.json
  def create
    if params[:user] && params[:user][:type]
      @user = params[:user][:type].constantize.new(user_params)
    else
      @user = User.new(user_params)
    end
    
    respond_to do |format|
      if @user && @user.save
        sign_in @user
        format.html { redirect_to user_path(@user), notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@user), notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :type)
      #Allowing :type for sample app to simplify testing.  
      #Would want to remove :type and handle User type assignment at the admin level only.
    end
end
