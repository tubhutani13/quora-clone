class Eval::QueryController < Eval::BaseController
  def show
  end

  def query1
    @questions = Question.published.joins(:answers).group("questions.id,answers.user_id").having("count(answers.id) > 1").includes(:user)
  end

  def query2
    @result = User.joins(comments: {answer: :question}).merge(Question.published)
      .group("users.id , questions.id")
      .having("count() > 1").pluck('users.name, questions.title, count()')
  end

  def query3
    @questions = Question.published
                         .joins(answers: :votes)
                         .where(votes: {amount: 1})
                         .where("votes.user_id = questions.user_id")
                         .group(:questions).includes(:answers)
  end

  def query4
    @questions = Question.published
      .joins(answers: :comments)
      .distinct.includes(:user)
    render :query1
  end

  def query5
    @users = User.joins(votes: :comment).where(votes: {amount: 1}).where(comments: { commentable_type: 'Question'})
  end

  def query6
    last_hour = 1.hour.ago
    @result = Question.left_outer_joins(:comments, answers: :comments )
      .merge(Comment.created_since(last_hour))
      .merge(Answer.created_since(last_hour))
      .where('comments_answers.created_at >= row?',last_hour)
      .group("questions.id")
      .having("activity_count > 0")
      .order("activity_count DESC")
      .limit(5)
      .pluck(Arel.sql("questions.title, COUNT(DISTINCT answers.id) + COUNT(DISTINCT comments_answers.id or comments.id) AS activity_count"))
  end


  def query7
    @result = Question.left_outer_joins(:comments, answers: :comments)
                         .where("answers.user_id = :user or comments.user_id = :user or comments_answers.user_id = :user", user: current_user.id)
                         .group("questions.id")
                         .order("activity_count DESC")
                         .distinct.pluck(Arel.sql('questions.title,count(DISTINCT answers.id) + count(DISTINCT comments_answers.id or comments.id) as activity_count'))
    render :query6
  end

  def query8
    @questions = Question.joins(:answers, :comments)
      .group("questions.id").pluck(Arel.sql('questions.title , (sum(answers.upvote_count) + sum(comments.upvote_count)) as upvotes, (sum(answers.downvote_count)+ sum(comments.downvote_count)) as downvotes'))
  end

  def query9
    @user = Credit.group("user_id")
      .order("sum(amount) desc")
      .first.user
  end

  def query10
    @user = User.joins(followers: :taggings)
    .group("users.id")
    .order(Arel.sql("COUNT(DISTINCT taggings.id) DESC")).first
  end
end
