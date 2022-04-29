FactoryBot.define do
  factory :session do
    trait :valid do
      user { create(:user, :valid) }
      # devices { create(:device, :valid, user: user) }
      token { JWT.encode({ user_id: user.id }, ENV['SECRET_KEY_BASE']) }
      expires_at { Time.now + 1.day }
      should_expire { true }
    end
  end
end
