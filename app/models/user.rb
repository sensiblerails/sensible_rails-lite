class User < ApplicationRecord
  has_secure_password
  
  has_many :posts, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  
  before_save :downcase_email
  
  # Create password reset token and update database
  def create_reset_digest
    token = SecureRandom.urlsafe_base64
    digest = Digest::SHA256.hexdigest(token)
    update_columns(
      reset_password_token: digest,
      reset_password_sent_at: Time.current
    )
    # Return the raw token for inclusion in email
    token
  end
  
  # Check if password reset token is expired
  def password_reset_expired?
    reset_password_sent_at.nil? || reset_password_sent_at < 2.hours.ago
  end
  
  private
  
  def downcase_email
    self.email = email.downcase if email.present?
  end
end
