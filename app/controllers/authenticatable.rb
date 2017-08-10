module Authenticatable
  # Included by ApplicationController
  extend ActiveSupport::Concern

  included do
    VERIFIER_SECRET = Rails.application.secrets.verifier_secret

    def log_in(user, permanent = false)
      return unless user

      user.touch(:last_login_at)
      @current_ability = nil
      @current_user = user

      cookies[:auth_token] = {
        value: user.auth_token,
        expires: (permanent ? 20.years.from_now : nil),
        domain: :all
      }
    end

    def log_in_as(user)
      session[:user_auth_token] = user.auth_token
      session[:impersonator_id] = @current_user.id
    end

    def logged_in_as?
      session[:user_auth_token].present?
    end

    def logged_in_as_id
      session[:impersonator_id]
    end

    def log_out_as
      session[:user_auth_token] = nil
      session[:impersonator_id] = nil
    end

    def log_out
      cookies.delete(:auth_token, domain: :all)
    end

    def verifier
      Rails.application.message_verifier(VERIFIER_SECRET)
    end

    def generate_user_token(id)
      verifier.generate([id, Time.current])
    end

    def get_user_by_token(token, threshold = 24.hours)
      user_id, time = verifier.verify(token)
      time > threshold.ago ? User.find(user_id) : nil
    end
  end
end