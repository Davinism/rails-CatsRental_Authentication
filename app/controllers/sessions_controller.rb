class SessionsController < ApplicationController

  before_action :check_logged_in, only: [:new]

  def create
    user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    if user && user.is_password?(session_params[:password])
      user.reset_session_token!
      login_user!(user)
      redirect_to cats_url
    else
      render :new
    end
  end

  def new
    render :new
  end

  def destroy
    logout_user!
    render :new
  end

  def check_logged_in
    if logged_in?
      redirect_to cats_url
    else

    end
  end

  private

  def session_params
    params.require(:users).permit(:user_name, :password)
  end
end
