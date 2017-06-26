require 'json'
require 'excon'

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
    anger = emotion_tones[0]['score']
    disgust = emotion_tones[1]['score']
    fear = emotion_tones[2]['score']
    joy = emotion_tones[3]['score']
    sadness = emotion_tones[4]['score']
    language_tones = tone_categories[1]['tones']
    analytical = language_tones[0]['score']
    confident = language_tones[1]['score']
    tentative = language_tones[2]['score']
    social_tones = tone_categories[2]['tones']
    openness = social_tones[0]['score']
    conscientiousness = social_tones[1]['score']
    extraversion = social_tones[2]['score']
    agreeableness = social_tones[3]['score']
    emotional_range = social_tones[4]['score']
    line =  "\n anger = " + anger.to_s + ",\n disgust = " + disgust.to_s + ",\n fear = " + fear.to_s + ",\n joy = " + joy.to_s + ",\n sadness = " + sadness.to_s + ",\n analytical = " + analytical.to_s + ",\n confident = " + confident.to_s + ",\n tentative = " + tentative.to_s + ",\n openness = " + openness.to_s + ",\n conscientiousness = " + conscientiousness.to_s + ",\n extraversion = " + extraversion.to_s + ",\n agreeableness = " + agreeableness.to_s + ",\n emotional_range = " + emotional_range.to_s
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