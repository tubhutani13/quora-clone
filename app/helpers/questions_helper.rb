module QuestionsHelper
  def extra_data(question)
    question.published? ? question.published_at.strftime('%m/%d %I:%M %p') : "nil"
  end
end
