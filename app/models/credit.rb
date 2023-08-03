class Credit < ApplicationRecord
  after_commit :sync_credits,if: :amount_previously_changed?
  enum description: {
    "New user credits" => 0,
    "Question Posted" => 1,
    "Upvote Reward" => 2,
    "Low Net votes" => 3,
    "Stripe Checkout" => 4,
  }
  belongs_to :user
  belongs_to :creditable, polymorphic: true

  validates :amount, numericality: { other_than: 0 }

  def sync_credits
    user.recompute_credits
  end
end
