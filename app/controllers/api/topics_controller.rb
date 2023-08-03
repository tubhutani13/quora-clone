class Api::TopicsController < Api::BaseController
    skip_before_action :authorize_user
    def index
        render json: Topic.all
    end

    def show
        @questions = Question.tagged_with(params[:topic]).includes(:user, :rich_text_content, { answers: [:user, :rich_text_content] }, {comments: [:user] }, :topics).order(created_at: :desc).where.not(published_at: false).limit(params[:x])
        render json: @questions, each_serializer: QuestionSerializer, include: ['user', 'answers.user', 'answers.comments.user', 'comments.user']    
    end
end
