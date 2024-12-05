class UsersController < ApplicationController
  #before_action :transform_params, only: [:create] 
  layout 'authentication'
  SECRET_KEY = Rails.application.secret_key_base

  def sign_up
    @user = User.new
  end

  def sign_in
    if current_user
      redirect_to root_path
    end
  end

  def create
    sleep(1)
    @user = User.new(user_params)
    if @user.save
      UserJob.perform_at(2.seconds.from_now,{ "user_id" => @user.id })
      flash.now[:success] = 'Registred Successfuly, kindly logg in'
      redirect_to sign_in_path
    else
      flash.now[:alert] = @user.errors.full_messages
      render_flash(:alert)
    end
  end

  # Login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      if params[:remember_me].to_i == 1
        user.remember
        cookies.permanent[:remember_token] = user.remember_token
      end

      redirect_to root_path
    else
      flash.now[:alert] = 'Invalid email or password.'
      render_flash(:alert)
    end
  end

  def logout
    session[:user_id] = nil
    current_user.forget if current_user
    cookies.delete(:remember_token)
    reset_session
    flash[:notice] = 'Logged out successfully'
    redirect_to sign_in_path
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :repeat_password, :gender, :is_active)
  end

  def generate_token(user_id)
    payload = { user_id: user_id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, SECRET_KEY)
  end

  def render_flash(type)
    render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash_message')
  end

  def transform_params
    if params[:user][:gender].is_a?(Array)
      params[:user][:gender] = params[:user][:gender].reject(&:blank?).first
    end
  end

end
