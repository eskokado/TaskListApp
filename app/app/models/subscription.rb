class Subscription < ApplicationRecord
  acts_as_tenant :user

  belongs_to :user

  has_one :credit_card, dependent: :destroy

  accepts_nested_attributes_for :credit_card

  enum plan: { free: 'free', premium: 'premium' }

  validates :plan, presence: true
  validate :credit_card_required_for_premium

  private

  def credit_card_required_for_premium
    if premium? && credit_card.blank?
      errors.add(:credit_card, "must be present for premium plan")
    end
  end
end
