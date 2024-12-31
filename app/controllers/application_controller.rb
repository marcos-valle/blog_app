class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def logged_in?
    session[:user_id]
  end

  def require_login
    if !logged_in?
      redirect_to login_path
    end
  end
end
