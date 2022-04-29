FactoryBot.define do
  factory :device do
    trait :valid do
      user
      name { Faker::Name.name }
      ip_address { Faker::Internet.ip_v4_address }
      user_agent { Faker::App.name }
      platform { Faker::Device.platform }
    end
  end
end
