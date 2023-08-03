class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true

  has_many :notifications_users, dependent: :destroy
  has_many :users, through: :notifications_users

end
