# spec/models/subscription_spec.rb
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:plan) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_one(:credit_card).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for credit card' do
      attributes = attributes_for(:subscription, :premium).merge(
        credit_card_attributes: attributes_for(:credit_card)
      )
      subscription = Subscription.new(attributes)
      expect(subscription.credit_card).to be_present
    end
  end
end
