class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # It simply checks if the session contains the user_id and, if it does, try to find the user with the specified id. helper_method ensures that this method can also be used in views. from http://www.sitepoint.com/youtube-api-version-3-rails/
  private

  ##
  # uses google authentication to keep track of user login and sesssions
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
end
