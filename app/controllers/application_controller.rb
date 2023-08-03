class ApplicationController < ActionController::Base
rescue_from ActiveRecord::RecordNotFound, with: :render_404
  include SessionsHelper
  before_action :set_global_search_variable
  before_action :authorize_user
  skip_before_action :authorize_user, only: [:search]

  def search
    index
    render 'home/index'
  end

  private

  def authorize_user
    unless logged_in?
      redirect_to login_url, notice: t("login_prompt")
    end
  end

  def set_global_search_variable
    @q = Question.published.ransack(params[:q])
  end

  def render_404
    render :file => "#{Rails.root}/public/404.html",  layout: false, status: :not_found
  end
end
