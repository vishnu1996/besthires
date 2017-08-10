class OauthController < ApplicationController
  def personality_insights(data)
    while data.length().to_i() < 600 do
      data = data + data
    end

    headers = {"content-type"=> "text/plain"}
    username = '42032262-0722-4258-a638-09933abfcb8a'
    password = 'PjmnftyEciKh'

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
    username = '02a04986-5453-4f87-a1da-09a145f7a56e'
    password = 'HJ1BZ6T53wWV'

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

  def watson_from_resume
    @resume = Resume.find(params[:resume_id])
    s3 = AWS::S3.new
    bucket = s3.buckets['besthires-production']
    resume_file_name = @resume.attachment.file.file
    resume_data = Yomu.new resume_file_name
    resume_data = resume_data.text
    # resume_doc = bucket.objects[resume_file_name]
    # Rails.logger.debug "#{resume_doc.read}"
    # resume_data = pdf_to_text(resume_doc.read)
    # resume_data = resume_data.text
    resume_data = resume_data.gsub("\t", " ")
    resume_data = resume_data.gsub("\n", " ")
    Rails.logger.debug "#{@resume.attachment.file.file}"
    analyze_tone(resume_data)
    personality_insights(resume_data)
    render :template => "oauth/watson"
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
        :raw_data => @auth_hash[:extra][:raw_info][:summary].to_s(),
        :access_token => @auth_hash[:credentials][:token].to_s(), 
        :secret => @auth_hash[:credentials][:secret].to_s()
      })

      oauth_account.save
    end
    # client = Twitter::REST::Client.new do |config|
    #   config.consumer_key        = ENV['TWITTER_API_KEY']
    #   config.consumer_secret     = ENV['TWITTER_API_SECRET']
    #   config.access_token        = @auth_hash[:credentials][:token].to_s()
    #   config.access_token_secret = @auth_hash[:credentials][:secret].to_s()
    # end
    # Rails.logger.debug "#{client}, #{client.home_timeline}"
    # response = client.require("https://api.twitter.com/1.1/statuses/home_timeline.json")
    # render :json => response.body
    if @auth_hash[:provider] == "twitter"
      recent_tweets
    elsif @auth_hash[:provider] == "linkedin"
      redirect_to oauth_success_path
    end
    # recent_tweets
    # redirect_to oauth_success_path
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

  def recent_tweets
        # Exchange your oauth_token and oauth_token_secret for an AccessToken instance.

    def prepare_access_token(oauth_token, oauth_token_secret)
        consumer = OAuth::Consumer.new(ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET'],
            { :site => "https://api.twitter.com"
            })
        # now create the access token object from passed values
        token_hash = { :oauth_token => oauth_token,
                                     :oauth_token_secret => oauth_token_secret
                                 }
        access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
        return access_token
    end

    auth = OauthAccount.find_by(:uid => session[:current_user_id], :provider => 'twitter')

    # Exchange our oauth_token and oauth_token secret for the AccessToken instance.
    Rails.logger.debug "\n\n#{auth['access_token']}, #{auth['secret']}"
    access_token = prepare_access_token(auth['access_token'], auth['secret'])
    Rails.logger.debug "\n\n#{access_token}"

    # use the access token as an agent to get the home timeline
    response = access_token.request(:get, "https://api.twitter.com/1.1/statuses/user_timeline.json?count=800&exclude_replies=true&trim_user=true")

    render :json => response.body
  end

  def pdf_to_text(pdf_filename)
    Docsplit.extract_text([pdf_filename], ocr: false, output: Dir.tmpdir)

    txt_file = File.basename(pdf_filename, File.extname(pdf_filename)) + '.txt'
    txt_filename = Dir.tmpdir + '/' + txt_file

    extracted_text = File.read(txt_filename)
    File.delete(txt_filename)

    extracted_text
  end
end