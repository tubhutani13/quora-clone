class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_global_search_variable

  def search
    index
    render :index
  end

  private

  def authorize_user
    unless logged_in?
      store_location
      flash[:danger] = t("login_prompt")
      redirect_to login_url
    end
  end

  def set_global_search_variable
    @q = Question.published_questions.ransack(params[:q])
  end
end
