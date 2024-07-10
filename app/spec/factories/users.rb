# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
    confirmed_at { Time.current }

    after(:create) do |user|
      user.confirm
    end
  end
end
