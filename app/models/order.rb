class Order < ApplicationRecord
  enum status: {
    in_cart: 0,
    pending: 1,
    cancelled: 2,
    failed: 3,
    success: 4,
  }

  belongs_to :user
  belongs_to :credit_pack

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :status, inclusion: statuses.keys
end
