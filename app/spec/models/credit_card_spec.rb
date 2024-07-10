# spec/models/credit_card_spec.rb
require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:user) { create(:user) }
  let(:subscription) { create(:subscription, user: user, plan: 'free') }
  let(:premium_subscription) { create(:subscription, :premium, user: user) }

  describe 'validations' do
    context 'when subscription is premium' do
      it 'is invalid without a card number' do
        credit_card = build(:credit_card, subscription: premium_subscription, card_number: nil)
        expect(credit_card).not_to be_valid
        expect(credit_card.errors[:card_number]).to include('Número do cartão não pode ficar em branco')
      end

      it 'is valid with a card number' do
        credit_card = build(:credit_card, subscription: premium_subscription)
        expect(credit_card).to be_valid
      end
    end

    context 'when subscription is not premium' do
      it 'is valid without a card number' do
        credit_card = build(:credit_card, subscription: subscription, card_number: nil)
        expect(credit_card).to be_valid
      end
    end
  end
end
