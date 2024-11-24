class User < ApplicationRecord
  attr_accessor :repeat_password
  has_secure_password

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validate :passwords_match
  validates :gender, inclusion: { in: %w[male female] }, allow_blank: false


  def password_required?
    password_digest.blank? || !password.nil?
  end

  def passwords_match
    if password != repeat_password
      errors.add(:repeat_password, "does not match the password")
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_token, User.digest(remember_token))
  end

  # For cookie management
  def forget
    update_attribute(:remember_token, nil)
  end

  # Class methods for token management
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def self.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
end
