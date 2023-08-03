class Admin::BaseController < ApplicationController
  before_action :authorize_admin

  private def authorize_admin
    redirect_to user_path(current_user) , notice: t('not_authorized') unless current_user.admin?
  end
end
