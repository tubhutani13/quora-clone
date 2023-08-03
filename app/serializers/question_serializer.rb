class QuestionSerializer < ActiveModel::Serializer
  include ContentHandler

  attributes :id, :title, :content, :permalink, :topic_list

  belongs_to :user
  has_many :answers
  has_many :comments
end
