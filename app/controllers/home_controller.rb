class HomeController < ApplicationController
  skip_before_action :authorize_user
  def index
    @topics = Topic.all
    @q = Question.published.ransack(ransack_params)
    @q.sorts = "title desc" if @q.sorts.empty?
    @feed_questions = @q.result(distinct: true)
  end

  private

  def ransack_params
    if params[:follow]
      { topics_name_in: (params[:query] || current_user&.topic_list), user_id_in: current_user.followees.ids }
    else
      { topics_name_in: (params[:query] || current_user&.topic_list), published_true: 1 }
    end
  end
end
