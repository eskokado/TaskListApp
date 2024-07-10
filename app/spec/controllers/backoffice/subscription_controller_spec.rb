# spec/controllers/backoffice/subscriptions_controller_spec.rb
require 'rails_helper'

RSpec.describe Backoffice::SubscriptionsController, type: :controller do
  describe 'PATCH #update' do
    let(:user) { FactoryBot.create(:user) }
    let(:subscription) { FactoryBot.create(:subscription, user: user) }
    let(:valid_params) do
      {
        id: subscription.id,
        subscription: {
          plan: 'premium',
          credit_card_attributes: {
            card_number: '1234567812345678'
          }
        }
      }
    end

    before(:each) do
      allow_any_instance_of(BackofficeController)
        .to receive(:authenticate_user!).and_return(true)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_user).and_return(user)
    end

    it 'updates the subscription' do
      patch :update, params: valid_params
      subscription.reload
      expect(subscription.plan).to eq('premium')
      expect(subscription.credit_card.card_number).to eq('1234567812345678')
    end

    it 'redirects to edit path on successful update' do
      patch :update, params: valid_params
      expect(response).to redirect_to(edit_backoffice_subscription_path(subscription))
      expect(flash[:notice]).to eq('Subscription was successfully updated.')
    end

    it 'renders edit template on failed update' do
      invalid_params = valid_params.deep_merge(subscription: { plan: '' }) # Invalid params to fail validation
      patch :update, params: invalid_params
      expect(response).to render_template(:edit)
    end
  end
end
