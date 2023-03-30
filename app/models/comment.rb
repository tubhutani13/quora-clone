class Comment < ApplicationRecord
  include ReportsHandler
  include VotesHandler


  belongs_to :commentable, polymorphic: true
  belongs_to :answer, -> { where( comments: { commentable_type: 'Answer' } ) }, foreign_key: 'commentable_id'
  belongs_to :question, -> { where( comments: { commentable_type: 'Question' } )}, foreign_key: 'commentable_id'
  belongs_to :user

scope :created_since,->(time){where(created_at: time..)}

  validates_presence_of :content
end
