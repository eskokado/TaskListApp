# spec/factories/tasks.rb
FactoryBot.define do
  factory :task do
    name { Faker::Lorem.sentence }
    status { 'pending' }
    association :task_list

    trait :completed do
      status { 'completed' }
    end
  end
end
