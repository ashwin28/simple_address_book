class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  protected
    # Returns the logged in user or nil if there isn't one
    def current_user
      return unless session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end

    # checks for a valid user
    def logged_in?
      current_user.is_a?(User)
    end

    # used by session and user create action to log user in
    def log_in(user)
      session[:user_id] = user.id
    end

    # used to remove user_id from session hash
    def log_out_user
      reset_session
    end

    # used in before_action on any controller action that requires a user account
    def authenticate
      logged_in? || access_denied
    end

    # redirect with friendly message
    def access_denied
      redirect_to login_path, notice: "Please log in to continue." and return false
    end
end

