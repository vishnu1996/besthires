class PasswordsController < ApplicationController

  def new
  end

  def create
    if @user = User.where("email ilike ?", resource_params[:email]).first
      @token = generate_user_token(@user.id)

      # UserMailer.password_reset_instructions(@user, @token, request.subdomain).deliver!

      redirect_to(new_password_path, success: t(:password_instructions_sent))
    else
      redirect_to(new_password_path, error: t(:email_not_found))
    end
  end

  def edit
    @password = Password.new(password: "", password_confirmation: "", token: params[:token])

    if current_user
      redirect_to root_path, error: t(:please_log_out_before_resetting_your_password)
    elsif @password.get_user_by_token(@password.token).nil?
      redirect_to(new_password_path, error: t(:invalid_password_reset_token))
    end
  end

  def update
    @password = Password.new(password_params)

    if @password.valid?
      @user = @password.get_user_by_token(@password.token)

      user_attributes = {
        password: password_params[:password],
        password_confirmation: password_params[:password_confirmation],
        force_password_change: true
      }

      if @user.update(user_attributes)
        log_in(@user)
        flash[:success] = t(:password_reset_successful)

        if @user.active_master_admin? || @user.is_organization_member?
          redirect_to(admin_path)
        else
          redirect_to(root_path)
        end
      else
        redirect_to(new_password_path, error: t(:invalid_password_reset_token))
      end
   else
     render :edit
   end
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to(new_password_path, error: t(:invalid_password_reset_token))
  end

  private

  def resource_params
    params.require(:password).permit(:email)
  end

  def password_params
    params.require(:password).permit(:password, :password_confirmation, :token)
  end
end