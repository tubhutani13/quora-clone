class NotificationsUserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :content, :time, :path

  def content
    object.notification.content
  end

  def time
    object.notification.created_at.in_time_zone('Kolkata').strftime("%I:%M %p")
  end

  def path
    "#{get_path(object.notification.notifiable_type, object.notification.notifiable_id)}"
  end

  def get_path(notifiable_type, notifiable_id)
    case notifiable_type
    when "Question"
      question = Question.find(notifiable_id)
      question_path(question.permalink)
    when "answer"
      question = Answer.find(notifiable_id).question
      question_path(question.permalink)
    when "Comment"
      comment = Comment.find(notifiable_id)
      if comment.commentable_type == "Question"
        question = comment.commentable
        question_path(question.permalink)
      elsif comment.commentable_type == "Answer"
        question = comment.commentable.question
        question_path(question.permalink)
      end
    when "User"
      user_path(notifiable_id)
    else
      ""
    end
  end
end
