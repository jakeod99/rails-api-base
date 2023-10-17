FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    username { "coolguy1000" }
    password { "super-$3cur3-PWD" }
  end
end
