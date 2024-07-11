class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.user_notfound"
    redirect_to root_path
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

  private
  def user_params
    params.require(:user).permit(User::INPUT_VALID_ATTRIBUTES)
  end
end
