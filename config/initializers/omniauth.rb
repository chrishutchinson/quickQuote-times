
# Google Keys for when in produciton
if  ENV['RAILS_ENV'] == "production"

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2,  ENV['GOOGLE_CLIENT_ID']  , ENV['GOOGLE_CLIENT_SECRET'], scope: 'userinfo.profile,youtube'
  end

  # Google Keys for whne in development
elsif ENV['RAILS_ENV'] ==  "development"

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2,  ENV['GOOGLE_CLIENT_ID_DEVELOPMENT']  , ENV['GOOGLE_CLIENT_SECRET_DEVELOPMENT'], scope: 'userinfo.profile,youtube'
  end


  # Google keys for testing, use same as production
    else

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2,  ENV['GOOGLE_CLIENT_ID']  , ENV['GOOGLE_CLIENT_SECRET'], scope: 'userinfo.profile,youtube'
  end


  end
