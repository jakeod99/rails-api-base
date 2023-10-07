RSpec.describe User, type: :model do
  it { should have_secure_password }
  it do 
    should validate_length_of(:password)
      .is_at_least(8)
      .is_at_most(ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED)
  end
  it { should validate_uniqueness_of :username }
  it do 
    should validate_length_of(:username)
      .is_at_least(4)
      .is_at_most(32)
  end
end
