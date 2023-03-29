class Eval::QueryController < Eval::BaseController
  def show
  end

  def query1
    @questions = Question.published.joins(:answers).group("questions.id,answers.user_id").having("count(answers.id) > 1").includes(:user)
  end

  def query2
    @users = User.select("users.name, questions.title as question_name, count() as count").joins(:comments)
      .joins("JOIN answers on comments.commentable_type = 'Answer' AND comments.commentable_id = answers.id join questions on questions.id = answers.question_id")
      .group("users.id , questions.id")
      .having("count() > 1")
  end

  def query3
    @questions = Question.select('questions.* , group_concat(answers.)').published
                         .joins(answers: :votes)
                         .where("votes.amount = 1 and votes.user_id = questions.user_id")
                         .group(:questions)
  end

  def query4
    @questions = Question.published
      .joins(answers: :comments)
      .distinct.includes(:user)
    render :query1
  end

  def query5
    @users = User.joins(:votes)
      .joins('join comments  on votes.voteable_type = "Comment" and votes.voteable_id= comments.id')
      .where("votes.amount = 1 and comments.commentable_type = 'Question'")
  end

  def query6
    last_hour = 1.hour.ago
    @questions = Question.select("questions.*, COUNT(DISTINCT answers.id) + COUNT(DISTINCT comments.id) + COUNT(DISTINCT answer_comments.id) AS activity_count")
      .joins("LEFT OUTER JOIN answers ON answers.question_id = questions.id AND answers.created_at >= '#{last_hour}'")
      .joins("LEFT OUTER JOIN comments ON comments.commentable_id = questions.id AND comments.commentable_type = 'Question' AND comments.created_at >= '#{last_hour}'")
      .joins("LEFT OUTER JOIN comments AS answer_comments ON answer_comments.commentable_id = answers.id AND answer_comments.commentable_type = 'Answer' AND answer_comments.created_at >= '#{last_hour}'")
      .group("questions.id")
      .having("activity_count > 0")
      .order("activity_count DESC")
      .limit(5)
  end

  def query7
    @questions = Question.select("questions.* , count(DISTINCT answers.id) + count(DISTINCT comments.id) + count(DISTINCT comments_answers.id) as activity_count")
                         .left_outer_joins(:comments)
                         .left_outer_joins(answers: :comments)
                         .where("answers.user_id = :user or comments.user_id = :user or comments_answers.user_id = :user", user: current_user.id).group("questions.id").order("activity_count DESC").distinct
    render :query6
  end

  def query8
    @questions = Question.select("questions.*, (sum(answers.upvote_count) + sum(comments.upvote_count)) as upvotes, (sum(answers.downvote_count)+ sum(comments.downvote_count)) as downvotes")
      .joins(:answers)
      .joins('join comments on comments.commentable_type = "Question" and comments.commentable_id = Questions.id')
      .group("questions.id")
  end

  def query9
    @user = Credit.select(:user_id)
      .group("user_id")
      .order("sum(amount) desc")
      .first.user
  end

  def query10
    @user = User.select("users.* , count(taggings.id) as follow_count")
      .joins(followers: :taggings)
      .group("users.id")
      .order("follow_count desc").first
  end
end
