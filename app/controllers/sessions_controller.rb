class SessionsController < ApplicationController

  def new
    # redirect users who are already logged in
    if logged_in?
      redirect_to user_path(current_user), alert: "You are already logged in."
    end
  end

  def create
    if user = User.authenticate(params[:username], params[:password])
      log_in(user)
      redirect_to root_path, notice: "You successfully logged in."
    else
      redirect_to login_path, alert: "Invalid login/password combination."
    end
  end

  def destroy
    log_out_user
    redirect_to login_path, notice: "You successfully logged out."
  end
end
