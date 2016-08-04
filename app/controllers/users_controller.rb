class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save!
      login_user!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = @users.errors.full_messages
      render :new
    end
  end

  def new
    render :new
  end

  private

  def user_params
    params.require(:users).permit(:user_name, :password)
  end

end
