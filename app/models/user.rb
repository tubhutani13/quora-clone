class User < ApplicationRecord
  include ::TokenHandler
  enum role: {
    "user" => 0,
    "admin" => 1,
  }

  before_create :generate_email_confirm_token
  after_create_commit :send_confirmation_email
  before_save :downcase_email
  before_update :add_verification_credits, if: :verified_at_changed?
  before_update :generate_auth_token, if: :verified_at_changed?

  has_many :questions, dependent: :restrict_with_error
  has_many :answers, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :credits, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_many :followed_users, foreign_key: :follower_id, class_name: "Follow"
  has_many :followees, through: :followed_users
  has_many :following_users, foreign_key: :followee_id, class_name: "Follow"
  has_many :followers, through: :following_users

  has_secure_password
  acts_as_taggable_on :topics
  has_one_attached :profile_picture, dependent: :destroy do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
    attachable.variant :mini, resize_to_limit: [40, 40]
  end

  validates :name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_set?

  def verified?
    verified_at?
  end

  def email_activate
    update(email_confirm_token: nil, verified_at: Time.current)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.now
    save
    UserMailer.forgot_password(id).deliver
  end

  def recompute_credits
    self.credits_count = self.credits.inject(0) { |sum, credit| sum += credit.amount }
    save!
  end

  def add_verification_credits
    credits.build({ amount: 5, creditable: User.find(1), description: 0 })
  end

  def generate_credits(amount, entity, description)
    credits.build({ amount: amount, creditable: entity, description: description })
    save
  end

  def banned?
    self.disabled_at?
  end

  def follow(user)
    self.followees << user if user
  end

  def unfollow(user)
    self.followed_users.find_by(followee_id: user.id)&.destroy
  end

  private

  def password_set?
    return !(self.password.blank? && !self.new_record?)
  end

  def send_confirmation_email
    UserMailer.registration_confirmation(id).deliver_later
  end

  def downcase_email
    self.email = email.downcase
  end

  def generate_email_confirm_token
    generate_token(:email_confirm_token)
  end

  def generate_auth_token
    generate_token(:auth_token)
  end
end
