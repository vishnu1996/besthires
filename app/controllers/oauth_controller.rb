class OauthController < ApplicationController
  @@config = { 
      :site => 'https://api.linkedin.com',
      :authorize_path => '/uas/oauth/authenticate',
      :request_token_path => '/uas/oauth/requestToken?scope=r_basicprofile',
      :access_token_path => '/uas/oauth/accessToken' 
  }

  def analyze_tone(data)
    headers = {"content-type"=> "text/plain"}
    username = 'ef685f83-c521-4ae0-933a-c5070675d337'
    password = 'ZQkeSVG6qWXL'

    response = Excon.post("https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?version=2016-05-19",
      :body => data,
      :headers => headers,
      :user => username,
      :password => password
    )

    profile = JSON.load(response.body)

    tone_categories = profile['document_tone']['tone_categories']
    emotion_tones = tone_categories[0]['tones']
    @emotion_tones_hash = Hash.new 
    @emotion_tones_hash[:Anger] = emotion_tones[0]['score']
    @emotion_tones_hash[:Disgust] = emotion_tones[1]['score']
    @emotion_tones_hash[:Fear] = emotion_tones[2]['score']
    @emotion_tones_hash[:Joy] = emotion_tones[3]['score']
    @emotion_tones_hash[:Sadness] = emotion_tones[4]['score']
    language_tones = tone_categories[1]['tones']
    @language_tones_hash = Hash.new
    @language_tones_hash[:Analytical] = language_tones[0]['score']
    @language_tones_hash[:Confident] = language_tones[1]['score']
    @language_tones_hash[:Tentative] = language_tones[2]['score']
    social_tones = tone_categories[2]['tones']
    @social_tones_hash = Hash.new
    @social_tones_hash[:Openness] = social_tones[0]['score']
    @social_tones_hash[:Conscientiousness] = social_tones[1]['score']
    @social_tones_hash[:Extraversion] = social_tones[2]['score']
    @social_tones_hash[:Agreeableness] = social_tones[3]['score']
    @social_tones_hash[:Emotional_range] = social_tones[4]['score']
    #line =  "\n anger = " + anger.to_s + ",\n disgust = " + disgust.to_s + ",\n fear = " + fear.to_s + ",\n joy = " + joy.to_s + ",\n sadness = " + sadness.to_s + ",\n analytical = " + analytical.to_s + ",\n confident = " + confident.to_s + ",\n tentative = " + tentative.to_s + ",\n openness = " + openness.to_s + ",\n conscientiousness = " + conscientiousness.to_s + ",\n extraversion = " + extraversion.to_s + ",\n agreeableness = " + agreeableness.to_s + ",\n emotional_range = " + emotional_range.to_s
  end

  def callback
  	begin
      @auth_hash = request.env['omniauth.auth']
      @watson_result = analyze_tone(@auth_hash[:extra][:raw_info][:summary])
      Rails.logger.debug "\n\n\n #{@watson_result}"
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
    end
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