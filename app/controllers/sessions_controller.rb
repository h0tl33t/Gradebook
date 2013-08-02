class SessionsController < ApplicationController
  def new
	end

	def create
		user = User.find_by(email: params[:session][:email])
		if user && user.authenticate(params[:session][:password])
			sign_in(user)
			flash[:success] = "Successfully logged in as #{user.full_name}."
			redirect_to root_path
		else
			flash[:error] = 'Not a valid email/password combination.'
			redirect_to sign_in
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
