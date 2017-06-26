class OauthController < ApplicationController
  @@config = { 
      :site => 'https://api.linkedin.com',
      :authorize_path => '/uas/oauth/authenticate',
      :request_token_path => '/uas/oauth/requestToken?scope=r_basicprofile',
      :access_token_path => '/uas/oauth/accessToken' 
  }
  def callback
  	begin
      @auth_hash = request.env['omniauth.auth']

      @auth_hash.each do |key,value|
        Rails.logger.debug "\n #{key} - #{value}"
      end
    	unless OauthAccount.where(uid: @auth_hash[:uid]).first
    		oauth_account = OauthAccount.new(oauth_account_params)
        oauth_account.save
      #   client = LinkedIn::Client.new('8196sktbspksp9', 'WBvSYefhd2Hn7vVb', @@config)
      #   client.authorize_from_access("8196sktbspksp9", "WBvSYefhd2Hn7vVb")
      #   Rails.logger.debug "\n\n\n #{client} \n #{client.authorize_from_access("8196sktbspksp9", "WBvSYefhd2Hn7vVb")}"
    		# Rails.logger.debug "\n\n\nEntered callback:  uid-#{@auth_hash[:uid]}, provider-#{@auth_hash[:provider]}
      #    \n\n profile_url - #{@auth_hash[:info][:urls][:public_profile]}
      #    \n\n connections - #{@auth_hash['num-connections']}"
    	end
    rescue => e
      flash[:alert] = "There was an error while trying to authenticate your account."
      Rails.logger.debug "#{e}"
      redirect_to oauth_failure_path
    end
  	#redirect_to root_path
    # begin
      # oauth = OauthService.new(request.env['omniauth.auth'])
      # if oauth_account = oauth.create_oauth_account!
      #     redirect_to root_path
      # end
    # rescue => e
    #   flash[:alert] = "There was an error while trying to authenticate your account."
    #   Rails.logger.debug "#{e}"
    #   redirect_to register_path
    # end
  end

  def oauth_account_params
    { uid: @auth_hash[:uid],
      provider: @auth_hash[:provider],
      image_url: @auth_hash[:info][:image],
      profile_url: @auth_hash[:info][:urls][:public_profile],
      raw_data: @auth_hash[:extra][:raw_info].to_json }
  end

  def failure
    flash[:alert] = "There was an error while trying to authenticate your account."
  end

end