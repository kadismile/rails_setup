class ApplicationController < ActionController::Base
  before_action :check_session_timeout, :set_current_user
  SECRET_KEY = Rails.application.secret_key_base


  def authenticate_user!
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = decode_token(token)
    @current_user = User.find(decoded[:user_id]) if decoded
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { errors: ['Unauthorized access'] }, status: :unauthorized
  end

  private

  def decode_token(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end

  def render_flash(type = nil)
    render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash_message', locals: { type: type })
  end

  def set_current_user
    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    elsif cookies[:remember_token]
      remember_token = cookies[:remember_token]
      user = User.find_by(remember_token: remember_token)
      if user
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  def current_user
    @current_user
  end
  helper_method :current_user
  
  def authorize_user!
    unless current_user
      flash[:alert] = 'You need to log in to access this page.'
      redirect_to sign_in_path
    end
  end

  def check_session_timeout
    if session[:expires_at] && session[:expires_at] < Time.current
      reset_session
      redirect_to sign_in_path, notice: 'You have been logged out due to inactivity.'
    else
      session[:expires_at] = 1.hours.from_now # Reset the expiration time on activity
    end
  end

end
