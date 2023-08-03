module VotesHandler
  def self.included(klass)
    klass.class_eval do
      cattr_accessor :creditable, instance_reader: true
      has_many :votes, as: :voteable, dependent: :destroy
      scope :by_most_upvoted, -> { order(Arel.sql("upvote_count - downvote_count DESC")) }

      def self.is_creditable
        self.creditable = true
      end
    end
  end

  def upvote(user_id)
    handle_vote(1, user_id)
  end

  def downvote(user_id)
    handle_vote(-1, user_id)
  end

  def handle_vote(vote_value, user_id)
    if @vote = votes.find_by(user_id: user_id)
      if @vote.amount == vote_value
        @vote.destroy
      else
        @vote.update(amount: vote_value)
      end
    else
      votes.create(user_id: user_id, amount: vote_value)
    end
  end

  def recompute_votes
    update(upvote_count: votes.where(amount: 1).pluck("amount").size)
    update(downvote_count: votes.where(amount: -1).pluck("amount").size)
    handle_resource_credits
  end

  def handle_resource_credits
    return unless creditable
    if net_votes >= MINIMUM_VOTES_TO_REWARD_CREDITS
      unless user.credits.where(creditable: self).last.try(:credit?)
        user.generate_credits(1, self, 2)
      end
    else
      if user.credits.where(creditable: self).last.try(:credit?)
        user.generate_credits(-1, self, 3)
      end
    end
  end

  def net_votes
    upvote_count - downvote_count
  end
end
