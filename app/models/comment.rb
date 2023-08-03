class Comment < ApplicationRecord
  include ReportsHandler
  include VotesHandler


  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates_presence_of :content
end
