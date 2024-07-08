class CreditCard < ApplicationRecord
  belongs_to :subscription

  validates :card_number, presence: true, if: :premium?

  private

  def premium?
    self.subscription.premium?
  end
end
