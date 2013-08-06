module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end

  def sign_out
    session[:user_id] = nil
    self.current_user = nil
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    redirect_to signin_path, notice: "You must sign-in before accessing this page."
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
