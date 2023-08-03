class User < ApplicationRecord
  include ::TokenHandler
  enum role: {
    "user" => 0,
    "admin" => 1,
  }


  before_create -> { generate_token(:email_confirm_token) }
  after_create_commit :send_confirmation_email
  before_save :downcase_email
  
  has_many :questions, dependent: :restrict_with_error
  has_many :answers, dependent: :nullify
  has_many :comments, dependent: :nullify

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
    verified_at.present?
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
end
