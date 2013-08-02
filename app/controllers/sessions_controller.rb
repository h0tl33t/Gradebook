class SessionsController < ApplicationController
  def new
	end

	def create
	  user = User.authenticate(params[:session][:email].downcase, params[:session][:password])
		if user
		  session[:user_id] = user.id
			redirect_to root_path
		else
			flash[:error] = 'Not a valid email/password combination.'
			redirect_to sign_in_path
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path, notice: 'Logged out.'
	end
end
