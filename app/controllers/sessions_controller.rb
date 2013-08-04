class SessionsController < ApplicationController
  def new
	end

	def create
	  user = User.find_by(email: params[:session][:email])
		if user && user.authenticate(params[:session][:password])
		  sign_in(user)
			redirect_to root_path
		else
		  flash.now[:error] = 'Not a valid email/password combination.'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path, notice: 'Logged out.'
	end
end
