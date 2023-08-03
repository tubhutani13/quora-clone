module SessionsHelper
  def log_in(user)
    cookies.encrypted[:user_id] = { 
        value: user.id,
        expires: cookie_expiration_time
      }
  end

  def current_user
    @current_user ||= User.find_by(id: cookies.encrypted[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    cookies.delete(:user_id)
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  private def cookie_expiration_time
    params[:remember_me] == '1' ? COOKIE_EXPIRATION_TIME : nil
  end
end
