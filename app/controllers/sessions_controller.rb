class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate(params.dig(:session, :password))  
      reset_session
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      flash[:success] = t "flash.login_success"
      redirect_to user, status: :see_other
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
end
