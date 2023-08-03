class Vote < ApplicationRecord
  after_commit :sync_votes
  before_destroy :sync_votes

  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :amount, presence: true, inclusion: { in: [1, -1] }

  def sync_votes
    @voteable = self.voteable
    @voteable.recompute_votes
  end

  def type
    if amount > 0
      "upvote"
    elsif amount < 0
      "downvote"
    end
  end
end
