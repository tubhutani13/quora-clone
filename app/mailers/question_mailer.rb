class QuestionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_mailer.answer_posted.subject
  #
  default :from => "me@mydomain.com"
  def answer_posted(answer_id)
    @answer = Answer.find(answer_id)
    @question = @answer.question
    @user = @question.user
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "Answer posted on you question")
  end

end
