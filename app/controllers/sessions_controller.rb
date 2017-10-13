class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.where("email ilike ?", params[:session][:email]).first

    if user && user.authenticate(params[:session][:password])
      permanent = params[:session][:remember_me] == '1'
      log_in(user, permanent)

      if !cookies[:invitation_token].blank?
        job_invitation
      else
        redirect_to(next_destination, success: t(:logged_in))
      end
    else
      flash.now[:error] = t(:invalid_email_or_password)
      render :new
    end
  end


  def update
    user = Organization::Member.find_by(id: params[:id]).try(:user)

    if user && current_user.try(:active_master_admin?)
      log_in_as(user)
      redirect_options = { success: t(:logged_in) }
    else
      redirect_options = { error: t(:user_not_found) }
    end

    redirect_to request.referrer, redirect_options
  end

  def update_for_candidate
    user = Candidate::Application.find_by(id: params[:id]).try(:user)

    if user && current_user.try(:active_master_admin?)
      log_in_as(user)
      redirect_options = { success: t(:logged_in) }
    else
      redirect_options = { error: t(:can_can_not_authorized) }
    end

    redirect_to candidate_applications_path, redirect_options
  end

  def success
  end

  def settings
  end

  def destroy
    if logged_in_as?
      log_out_as
      redirect_path = request.referrer.presence || root_path
      redirect_to(redirect_path, info: t(:logged_out))
    else
      log_out
      redirect_to(root_path, info: t(:logged_out))
    end
  end

  def linked_in
    return_to = request.referrer.present? ? request.referrer : root_path

    if current_user
      redirect_to return_to, info: t(:logged_in)
    else
      if params[:code].present? && access_token = linkedin_oauth.get_access_token(params[:code])
        profile = LinkedIn::API.new(access_token).profile(fields: ['first-name', 'last-name', 'email-address'])

        user = User.find_or_initialize_by(email: profile.email_address) do |u|
          u.first_name = profile.first_name
          u.last_name = profile.last_name
          u.assign_random_password
        end

        redirect_message = if user.new_record?
          user.save # TODO: Notify?
          t(:signed_up)
        else
          t(:logged_in)
        end

        log_in(user)

        redirect_to return_to, success: redirect_message
      else
        redirect_to linkedin_oauth.auth_code_url
      end
    end
  end

  private

  def linkedin_oauth
    @linkedin_oauth ||= LinkedIn::OAuth2.new
  end
  
  def job_invitation
    job_invitation = Job::Invitation.find_by(token: cookies[:invitation_token])
      
    if job_invitation.present?
      job_opening = Job::Opening.active.open.find_by(id: job_invitation.job_opening_id)
        if !job_opening.nil?
          redirect_to new_job_opening_candidate_application_path(job_opening)
        else
          redirect_to(next_destination, success: t(:logged_in))
        end
    else
      redirect_to(next_destination, success: t(:logged_in))
    end
  end

  def next_destination
    if next_url = session.delete(:redirect_path)
      next_url
    else
      :success
    end
  end
end
