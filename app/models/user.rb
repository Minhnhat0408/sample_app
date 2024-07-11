class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  INPUT_VALID_ATTRIBUTES = %i(name email password password_confirmation).freeze

  before_save :downcase_email
  validates :name, presence: true,
    length: {maximum: Settings.models.user.name_length}
  validates :email, presence: true,
    length: {maximum: Settings.models.user.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
