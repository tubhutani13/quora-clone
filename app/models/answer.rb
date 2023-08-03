class Answer < ApplicationRecord
  include CommentsHandler
  
  after_create_commit :send_confirmation_email
  validates_presence_of :answer_body

  belongs_to :user
  belongs_to :question

  has_rich_text :answer_body
  

  def send_confirmation_email
    QuestionMailer.answer_posted(self.id)
  end
end
