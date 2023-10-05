class User < ApplicationRecord
  has_secure_password
  validates :password, length: { in: 8..ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED }
  validates :username, uniqueness: true
  validates :username, length: { in: 4..32 }
end
