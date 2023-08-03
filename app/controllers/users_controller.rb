class UsersController < ApplicationController
  before_action :authorize_user, only: [:show]
  before_action :set_user, only: [:show, :edit, :update, :questions_data, :follow, :unfollow]
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
    if current_user.follow(@user)
      flash[:success] = "User followed successfully"
    else
      flash[:error] = "error in following"
    end
    redirect_back(fallback_location: user_path(@user))
  end

  def unfollow
    if current_user.unfollow(@user)
      flash[:success] = "User unfollowed successfully"
    else
      flash[:error] = "error in unfollowing"
    end
    redirect_back(fallback_location: user_path(@user))
  end

  def credits
    @user = current_user
    @credits = current_user.credits
  end

  def questions_data
    @questions = @user.questions.published.joins(:comments).group(:questions).having("comments.created_at > #{Date.today() - 1.day()} and count() > 0")
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
