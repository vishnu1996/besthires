class OauthController < ApplicationController
  def personality_insights(data)
    while data.length().to_i() < 600 do
      data = data + data
    end

    headers = {"content-type"=> "text/plain"}
    username = '5c47845f-324e-4bd9-a28a-f5e66bc3c85f'
    password = 'cvQyB31FdHY7'

    response = Excon.post("https://gateway.watsonplatform.net/personality-insights/api/v3/profile?version=2016-10-20",
      :body => data,
      :headers => headers,
      :user => username,
      :password => password
    )

    profile = JSON.load(response.body)

    personality_category = profile['personality']

    openness_traits = personality_category[0]['children']
    @openness_traits_hash = Hash.new 
    @openness_traits_hash[:Adventurousness] = openness_traits[0]['percentile']
    @openness_traits_hash[:Artistic_interests] = openness_traits[1]['percentile']
    @openness_traits_hash[:Emotionality] = openness_traits[2]['percentile']
    @openness_traits_hash[:Imagination] = openness_traits[3]['percentile']
    @openness_traits_hash[:Intellect] = openness_traits[4]['percentile']
    @openness_traits_hash[:Authority_challenging] = openness_traits[5]['percentile']
    
    conscientiousness_traits = personality_category[1]['children']
    @conscientiousness_traits_hash = Hash.new 
    @conscientiousness_traits_hash[:Achievement_striving] = conscientiousness_traits[0]['percentile']
    @conscientiousness_traits_hash[:Cautiousness] = conscientiousness_traits[1]['percentile']
    @conscientiousness_traits_hash[:Dutifulness] = conscientiousness_traits[2]['percentile']
    @conscientiousness_traits_hash[:Orderliness] = conscientiousness_traits[3]['percentile']
    @conscientiousness_traits_hash[:Self_discipline] = conscientiousness_traits[4]['percentile']
    @conscientiousness_traits_hash[:Self_efficacy] = conscientiousness_traits[5]['percentile']

    extraversion_traits = personality_category[2]['children']
    @extraversion_traits_hash = Hash.new 
    @extraversion_traits_hash[:Activity_level] = extraversion_traits[0]['percentile']
    @extraversion_traits_hash[:Assertiveness] = extraversion_traits[1]['percentile']
    @extraversion_traits_hash[:Cheerfulness] = extraversion_traits[2]['percentile']
    @extraversion_traits_hash[:Excitement_seeking] = extraversion_traits[3]['percentile']
    @extraversion_traits_hash[:Outgoing] = extraversion_traits[4]['percentile']
    @extraversion_traits_hash[:Gregariousness] = extraversion_traits[5]['percentile']

    agreeableness_traits = personality_category[3]['children']
    @agreeableness_traits_hash = Hash.new 
    @agreeableness_traits_hash[:Altruism] = agreeableness_traits[0]['percentile']
    @agreeableness_traits_hash[:Cooperation] = agreeableness_traits[1]['percentile']
    @agreeableness_traits_hash[:Modesty] = agreeableness_traits[2]['percentile']
    @agreeableness_traits_hash[:Uncompromising] = agreeableness_traits[3]['percentile']
    @agreeableness_traits_hash[:Sympathy] = agreeableness_traits[4]['percentile']
    @agreeableness_traits_hash[:Trust] = agreeableness_traits[5]['percentile']

    emotional_range_traits = personality_category[4]['children']
    @emotional_range_traits_hash = Hash.new 
    @emotional_range_traits_hash[:Fiery] = emotional_range_traits[0]['percentile']
    @emotional_range_traits_hash[:Prone_to_worry] = emotional_range_traits[1]['percentile']
    @emotional_range_traits_hash[:Melancholy] = emotional_range_traits[2]['percentile']
    @emotional_range_traits_hash[:Immoderation] = emotional_range_traits[3]['percentile']
    @emotional_range_traits_hash[:Self_consciousness] = emotional_range_traits[4]['percentile']
    @emotional_range_traits_hash[:Susceptible_to_stress] = emotional_range_traits[5]['percentile']

    needs_traits = profile['needs']

    @needs_traits_hash = Hash.new 
    @needs_traits_hash[:Challenge] = needs_traits[0]['percentile']
    @needs_traits_hash[:Closeness] = needs_traits[1]['percentile']
    @needs_traits_hash[:Curiosity] = needs_traits[2]['percentile']
    @needs_traits_hash[:Excitement] = needs_traits[3]['percentile']
    @needs_traits_hash[:Harmony] = needs_traits[4]['percentile']
    @needs_traits_hash[:Ideal] = needs_traits[5]['percentile']
    @needs_traits_hash[:Liberty] = needs_traits[0]['percentile']
    @needs_traits_hash[:Love] = needs_traits[1]['percentile']
    @needs_traits_hash[:Practicality] = needs_traits[2]['percentile']
    @needs_traits_hash[:Self_expression] = needs_traits[3]['percentile']
    @needs_traits_hash[:Stability] = needs_traits[4]['percentile']
    @needs_traits_hash[:Structure] = needs_traits[5]['percentile']

    values_traits = profile['values']

    @values_traits_hash = Hash.new 
    @values_traits_hash[:Conservation] = values_traits[0]['percentile']
    @values_traits_hash[:Openness_to_change] = values_traits[1]['percentile']
    @values_traits_hash[:Hedonism] = values_traits[2]['percentile']
    @values_traits_hash[:Self_enhancement] = values_traits[3]['percentile']
    @values_traits_hash[:Self_transcendence] = values_traits[4]['percentile']
    
  end

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

  def watson
  	if session[:current_user_id] == nil
       flash[:alert] = "Unauthorized access"
      redirect_to new_user_session_path
    else
      @auth_hash = request.env['omniauth.auth']
      data = OauthAccount.find_by(uid: session[:current_user_id])
      analyze_tone(data.raw_data)
      personality_insights(data.raw_data)
    end
  end

  def callback
    @auth_hash = request.env['omniauth.auth']
    session[:current_user_id] = @auth_hash[:uid]
    @auth_hash.each do |key,value|
      Rails.logger.debug "\n #{key} - #{value}"
    end

    unless OauthAccount.where(uid: @auth_hash[:uid]).first
      oauth_account = OauthAccount.new({
        :uid => @auth_hash[:uid].to_s(),
        :provider => @auth_hash[:provider].to_s(),
        :image_url => @auth_hash[:info][:image].to_s(),
        :profile_url => @auth_hash[:info][:urls][:public_profile].to_s(),
        :raw_data => @auth_hash[:extra][:raw_info][:summary].to_s
      })

      oauth_account.save
    end
    redirect_to oauth_success_path
  end

  def success
    if session[:current_user_id] == nil
       flash[:alert] = "Unauthorized access"
      redirect_to new_user_session_path
    end
  end

  def failure
    flash[:alert] = "There was an error while trying to authenticate your account."
  end

  def logout
    session[:current_user_id] = nil
    redirect_to new_user_session_path
  end
end