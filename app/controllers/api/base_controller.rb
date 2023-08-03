class Api::BaseController < ActionController::Base
  before_action :authorize_user

  private def authorize_user
    unless current_user
        render json: { error: t('invalid_auth_token') }, status: :unprocessable_entity
    end
  end

  private def current_user
    @current_user ||= User.find_by(auth_token: params[:token])
  end
end
