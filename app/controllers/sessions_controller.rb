class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user.authenticate(params.dig(:session, :password))
      handle_create_success @user
    else
      flash.now[:danger] = t "auth.invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    flash[:success] = t "flash.logout_success"
    redirect_to root_url, status: :see_other
  end

  private

  def load_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return if @user

    flash.now[:danger] = t "auth.user_failed"
    render :new, status: :unprocessable_entity
  end

  def handle_create_success user
    forwarding_url = session[:forwarding_url]
    reset_session
    log_in user
    params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
    flash[:success] = t "flash.login_success"
    redirect_to forwarding_url || user, status: :see_other
  end
end
