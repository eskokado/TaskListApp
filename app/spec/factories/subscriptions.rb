# spec/factories/subscriptions.rb
FactoryBot.define do
  factory :subscription do
    plan { 'free' }
    association :user

    trait :premium do
      plan { 'premium' }
      after(:build) do |subscription|
        subscription.credit_card = build(:credit_card, subscription: subscription)
      end
    end
  end
end
