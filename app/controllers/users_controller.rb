class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)
      redirect_to(root_path, success: t(:signed_up))
    else
      render :new
    end
  end

  def edit
    session[:profile_referrer] = request.referrer
  end

  def update
    if @user.update(user_params)
      if session[:profile_referrer]
        redirect_to session.delete(:profile_referrer)
      end
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation,
      :location,
      :city,
      :state,
      :country,
      :current_password,
    )
  end
end
