# app/controllers/backoffice/subscriptions_controller.rb
module Backoffice
  class SubscriptionsController < BackofficeController
    before_action :set_subscription, only: [:edit, :update]

    set_current_tenant_through_filter

    before_action :set_tenant

    def edit
      @subscription.build_credit_card unless @subscription.credit_card
    end

    def update
      if @subscription.update(subscription_params)
        handle_credit_card_attributes
        redirect_to edit_backoffice_subscription_path, notice: t('.update')
      else
        render :edit
      end
    end

    private

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def subscription_params
      params.require(:subscription).permit(:user_id, :plan, credit_card_attributes: [:id, :card_number])
    end

    def set_tenant
      set_current_tenant(current_user)
    end

    def handle_credit_card_attributes
      if @subscription.free?
        @subscription.credit_card.destroy if @subscription.credit_card.present?
      elsif @subscription.premium?
        if @subscription.credit_card.present?
          @subscription.credit_card.update(credit_card_params)
        else
          @subscription.build_credit_card(credit_card_params)
        end
      end
    end

    def credit_card_params
      params.require(:subscription).fetch(:credit_card_attributes, {}).permit(:id, :card_number)
    end
  end
end
