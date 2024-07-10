# spec/factories/credit_cards.rb
FactoryBot.define do
  factory :credit_card do
    card_number { Faker::Finance.credit_card }
    association :subscription
  end
end
