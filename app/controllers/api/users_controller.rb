class Api::UsersController < Api::BaseController
  def feed
    @questions = Question.tagged_with(current_user.topic_list, :any => true).includes(:user, :rich_text_content, { answers: [:user, :rich_text_content] }, { comments: [:user] }, :topics).order(created_at: :desc).where.not(published_at: false)
    render json: @questions, each_serializer: QuestionSerializer, include: ["user", "answers.user", "answers.comments.user", "comments.user"]
  end
end
