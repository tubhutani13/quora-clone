class AnswerSerializer < ActiveModel::Serializer
  include ContentHandler
  attributes :id, :content
  belongs_to :user
  has_many :comments
end
