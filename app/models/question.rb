class Question < ApplicationRecord
  include ::TokenHandler
  include CommentsHandler
  include ReportsHandler

  belongs_to :user
  has_many :answers, dependent: :restrict_with_error
  has_many :credits, as: :creditable
  has_many :notifications, as: :notifiable

  before_create -> { generate_token(:permalink) }
  before_save :ensure_published_question_cannot_be_drafted
  after_commit :send_notifications, if: :recently_published, on: [:create, :update]

  with_options if: :published? do
    validates :title, presence: true, uniqueness: true
    validates :content, presence: true, length: { minimum: 15 }
    validates :topic_list, presence: true
    validates :published_at, min_credits: true
  end

  belongs_to :user
  has_one_attached :pdf_attachment
  has_rich_text :content
  acts_as_taggable_on :topics

  private def ensure_published_question_cannot_be_drafted
    if published_at_changed? && published_at_change[0] != nil && published_at_change[1] == nil
      errors.add(:base, "Published question cannot be Drafted")
      throw :abort
    end
  end

  def to_param
    permalink
  end

  def publish_question(published)
    check_publish(published)
    save
  end

  def update_question(params, published)
    check_publish(published)
    update(params)
  end

  def check_publish(published)
    if published
      self.published_at = Time.now
    end
  end

  def send_notifications
    users = User.tagged_with(topic_list, any: true).where.not(id: self.user_id)
    notification = notifications.create(content: "Question posted related to your interested topic")
    notification.users << users
  end

  def recently_published
    published_at_previous_change & [0] == nil
  end
end
