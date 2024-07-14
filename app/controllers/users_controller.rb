class UsersController < ApplicationController
  include Pagy::Backend
  before_action :logged_in_user, except: %i(show new create)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.user_notfound"
    redirect_to root_path
  end

  def index
    @pagy, @users = pagy User.order_by_name, items:
      Settings.page_10
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      # Handle a successful save.
      reset_session
      log_in @user
      flash[:success] = t "flash.user_create"
      redirect_to @user, status: :see_other
    else
      flash.now[:danger] = t "flash.user_failed"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update user_params
      # Handle a successful update.
      flash[:success] = t "flash.profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t "flash.user_updated_failed"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.user_deleted"
    else
      flash[:danger] = t "flash.user_delete_failed"
    end
    redirect_to users_path
  end

  private

  def admin_user
    return if current_user.admin?

    flash[:danger] = t "auth.unauthorized"
    redirect_to root_path
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "flash.user_notfound"
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.please_log_in"
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:error] = t "flash.unauthorized"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit(User::INPUT_VALID_ATTRIBUTES)
  end
end
