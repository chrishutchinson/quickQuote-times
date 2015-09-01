##
# Handles the user login, using Google authentication, creating and destroying sessions as needed.
class SessionsController < ApplicationController
  ##
  # `request.env['omniauth.auth']` contains all the information sent by the server to our app
  # (it is called the `auth hash`).  from  http://www.sitepoint.com/youtube-api-version-3-rails
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    flash[:success] = "Welcome, #{user.name}"
    redirect_to user_videos_path(user)
    #redirect_to user_videos_path(user)
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Goodbye!"
    redirect_to root_url
  end
end