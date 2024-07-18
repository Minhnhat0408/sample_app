class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def edit; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash.email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "flash.email_not_found"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t("errors.messages.blank")
      render :edit, status: :unprocessable_entity
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "flash.password_reset"
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "flash.user_not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "flash.user_not_activated"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "flash.password_reset_expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit User::RESET_PASS_INPUT_VALID_ATTRIBUTES
  end
end
