# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  validates :user_name, :password_digest, :session_token, presence: true
  validates :session_token, uniqueness: true
  validates :password, length: { minimum: 8, allow_nil: true }

  attr_reader :password

  after_initialize :ensure_session_token

  def self.find_by_credentials(username, pw)
    user = User.find_by(user_name: username)
    return user if user && user.is_password?(pw)
    nil
  end

  has_many :cats 

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(32)
  end

  def reset_session_token!
    random_token = SecureRandom::urlsafe_base64(32)
    until random_token != self.session_token
      random_token = SecureRandom::urlsafe_base64(32)
    end
    self.session_token = random_token
    self.save!
    self.session_token
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    pw_digest = BCrypt::Password.new(self.password_digest)
    pw_digest.is_password?(pw)
  end

end
