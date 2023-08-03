class UsersController < ApplicationController
  before_action :authorize_user, only: [:show]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_user_by_email_confirm_token, only: [:confirm_email]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t("confirm_email")
      redirect_to root_url
    else
      flash[:error] = t("error")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path, notice: t("profile_update_success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_email
    if @user.email_activate
      flash[:success] = t("email_activated")
      redirect_to login_url
    else
      flash[:error] = t("error")
      redirect_to root_url
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.followees << @user
    redirect_back(fallback_location: user_path(@user))
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.find_by(followee_id: @user.id).destroy
    redirect_back(fallback_location: user_path(@user))
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_picture, topic_list: [])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_user_by_email_confirm_token
    @user = User.find_by_email_confirm_token(params[:id])
    unless @user
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end
end
