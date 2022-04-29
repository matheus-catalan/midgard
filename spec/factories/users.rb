FactoryBot.define do
  factory :user do
    trait :valid do
      name { Faker::Name.name }
      email { Faker::Internet.email }
      password { Faker::String.random(length: 10) }
      status { true }
    end

    trait :without_name do
      name {  nil }
      email { Faker::Internet.email }
      password { Faker::String.random(length: 10) }
      status { rand(1..2) == 1 }
    end

    trait :with_invalid_name do
      name { Faker::String.random(length: rand(51..200)) }
      email { Faker::Internet.email }
      password { Faker::String.random(length: 10) }
      status { rand(1..2) == 1 }
    end

    trait :without_password do
      name {  Faker::Name.name }
      email { Faker::Internet.email }
      password { nil }
      status { rand(1..2) == 1 }
    end

    trait :without_email do
      name { Faker::Name.name }
      email { nil }
      password { Faker::String.random(length: 10) }
      status { rand(1..2) == 1 }
    end

    trait :with_invalid_email do
      name { Faker::Name.name }
      email { Faker::String.random(length: 10) }
      password { Faker::String.random(length: 10) }
      status { rand(1..2) == 1 }
    end
  end
end
