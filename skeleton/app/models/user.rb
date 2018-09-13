class User < ApplicationRecord
  validates :username, :password_digest, :session_token, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  after_initialize :ensure_session_token
  
  attr_reader :password
  
  has_many :cats,
  foreign_key: :owner_id,
  class_name: :Cat
  
  has_many :cat_rental_requests
  
  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end
  
  def reset_session_token
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end
  
  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return user if user && user.is_password?(password)
    nil
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
  
end