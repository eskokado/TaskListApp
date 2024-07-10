# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  describe 'associations' do
    it { should have_many(:task_lists) }
    it { should have_one(:subscription).dependent(:destroy) }
  end

  describe 'callbacks' do
    context 'after_commit :create_free_subscription' do
      it 'creates a free subscription after confirmation' do
        user.update(confirmed_at: Time.current)
        expect(user.subscription).to be_present
        expect(user.subscription.plan).to eq('free')
      end
    end
  end
end
