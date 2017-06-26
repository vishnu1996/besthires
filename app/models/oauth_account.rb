class OauthAccount < ActiveRecord::Base
	attr_accessor :provider, :uid, :image_url, :profile_url, :access_token, :raw_data, :user_id

	belongs_to :user
end
