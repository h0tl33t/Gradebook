module SessionsHelper
  def sign_in(user)
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def sign_out
		cookies.delete(:remember_token)
		self.current_user = nil
	end

	def authenticate
		deny_access unless signed_in?
	end

	def deny_access
		redirect_to signin_path, :notice => "You must sign-in before accessing this page."
	end

	def signed_in?
		current_user
	end

	def current_user?(user)
		user == current_user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by(remember_token: cookies[:remember_token])
	end
end
