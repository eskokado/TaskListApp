# spec/factories/task_lists.rb
FactoryBot.define do
  factory :task_list do
    name { Faker::Lorem.sentence }
    shared { false }
    association :user

    trait :shared do
      shared { true }
    end
  end
end
