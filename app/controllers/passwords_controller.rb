class PasswordsController < ApplicationController
  before_action :set_user_by_password_reset_token, only: [:edit, :update]
  before_action :set_user_by_email, only: [:create]
  before_action :check_password_expiration, only: [:update]

  def new
  end

  def create
    @user.send_password_reset
    flash[:notice] = t("email_sent")
    redirect_to new_session_path
  end

  def update
    if @user.update(user_params)
      flash[:notice] = t("password_reset_success")
      redirect_to new_session_path
    else
      render :edit
    end
  end 

  private

  def user_params
    params.require(:user).permit(:password)
  end

  def set_user_by_password_reset_token
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def set_user_by_email
    @user = User.find_by_email(params[:email])
    unless @user
      flash[:error] = "Invalid email address"
      render :new, status: :unprocessable_entity
    end
  end

  def check_password_expiration
    if @user.password_reset_sent_at < 2.hour.ago
      flash[:notice] = t("password_expired")
      redirect_to new_password_path
    end
  end
end
