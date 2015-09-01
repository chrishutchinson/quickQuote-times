class User < ActiveRecord::Base
	has_many :videos

  ##
  # Here the `find_or_initialize_by` method is used. It tries to find a user with the provided uid and, if found,
  # the record is returned as a result. If it is not found, a new object is created and returned.
  # This is done to avoid situations when the same user is being created multiple times.
  # We then fetch the user’s name and token, save the record, and return it.
  # from  http://www.sitepoint.com/youtube-api-version-3-rails/
  class << self
		def from_omniauth(auth)
			user = User.find_or_initialize_by(uid: auth['uid'])
			user.name = auth['info']['name']
			user.token = auth['credentials']['token']
			user.save!
			user
		end
  end

end

