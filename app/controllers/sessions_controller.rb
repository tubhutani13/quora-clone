class SessionsController < ApplicationController
  skip_before_action :authorize_user
  before_action :set_user, only: [:create]
  before_action :authenticate_user, only: [:create]

  def create
    if @user.verified?
      log_in @user
      case
      when @user.banned?
        redirect_to login_url, notice: t('disabled_account.', disable_day: @user.disabled_at.to_date)
      when @user.admin?
        redirect_to admin_path
      else
        redirect_to root_url
      end
    else
      flash.now[:error] = "Please activate your account by following the 
        instructions in the account confirmation email you received to proceed"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private def set_user
    unless @user = User.find_by(email: params[:email].downcase)
      redirect_to login_url, notice: t("invalid_email_pass_combination")
    end
  end

  private def authenticate_user
    unless @user.authenticate(params[:password])
      redirect_to login_url, notice: t("invalid_email_pass_combination")
    end
  end
end
