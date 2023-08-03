class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :content
  belongs_to :user
  has_many :comments

  def content
    object.content.to_plain_text
  end
end
