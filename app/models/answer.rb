class Answer < ApplicationRecord
  include CommentsHandler
  include ReportsHandler
  include VotesHandler

  after_create_commit :send_confirmation_email
  before_create :set_publish_time

  validates_presence_of :content

  belongs_to :user
  belongs_to :question
  is_creditable
  has_rich_text :content

  def send_confirmation_email
    QuestionMailer.answer_posted(self.id)
  end

  def set_publish_time
    self.published_at = Time.now
  end
end
