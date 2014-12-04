class UsersController < ApplicationController
  before_action :authenticate, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]

  # this is the default root of app for now
  def new
    # need the redirect for logged in users
    if logged_in?
      redirect_to current_user
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)
      redirect_to @user, notice: 'Your account was successfully created.'
    else
      render action: :new
    end
  end

  def show
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Your user information was successfully updated.'
    else
      render action: :edit
    end
  end

  private
    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:username, :name, :password, :password_confirmation)
    end
end
