class Question < ApplicationRecord
  include ::TokenHandler
  include CommentsHandler
  
  belongs_to :user
  has_many :answers, dependent: :restrict_with_error

  scope :published_questions, -> { where.not(published_at: :nil) }
  before_create -> { generate_token(:permalink) }
  before_save :ensure_published_question_cannot_be_drafted

  with_options if: :published? do
    validates :title, presence: true, uniqueness: true
    validates :content, presence: true, length: { minimum: 15 }
    validates :topic_list, presence: true
  end

  belongs_to :user
  has_one_attached :pdf_attachment
  has_rich_text :content
  acts_as_taggable_on :topics

  private def ensure_published_question_cannot_be_drafted
    if changes[:published] == [true, false]
      errors.add(:base, "Published question cannot be Drafted")
      throw :abort
    end
  end

  def to_param
    permalink
  end

  def published?
    self.published_at.present?
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
end
