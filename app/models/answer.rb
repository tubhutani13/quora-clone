class Answer < ApplicationRecord
  include CommentsHandler
  include ReportsHandler
  include VotesHandler

  scope :created_since,->(time){where(created_at: time..)}

  after_create_commit :send_confirmation_email
  validates_presence_of :content

  belongs_to :user
  belongs_to :question
  is_creditable
  has_rich_text :content

  def send_confirmation_email
    QuestionMailer.answer_posted(self.id)
  end
end
