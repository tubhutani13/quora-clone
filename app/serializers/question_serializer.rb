class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title,:content, :permalink, :topic_list
  belongs_to :user
  has_many :answers
  has_many :comments

  def content
    object.content.to_plain_text
  end
end
