class Comment < ApplicationRecord
  include ReportsHandler
  include VotesHandler
  
  scope :published_comments, -> { where.not(published_at: :nil) }

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates_presence_of :content
end
