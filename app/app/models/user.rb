class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  validates :username, presence: true, uniqueness: true

  has_many :task_lists
  has_one :subscription, dependent: :destroy

  after_commit :create_free_subscription, if: :confirmed_at_changed? && :confirmed_at_present?

  private

  def create_free_subscription
    return if subscription.present?

    self.create_subscription!(plan: :free)
  end

  def confirmed_at_present?
    confirmed_at.present?
  end
end
