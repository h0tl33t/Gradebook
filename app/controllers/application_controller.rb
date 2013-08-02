class ApplicationController < ActionController::Base
  #include SessionsHelper
  include SemestersHelper
  
  helper_method :current_user, :signed_in?
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def signed_in?
    session[:user_id]
  end
  
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    #No matter what I do, this never memoizes..WTF? It's making calls on every page.
  end
end
