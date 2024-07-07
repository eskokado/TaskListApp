class TaskList < ApplicationRecord
  acts_as_tenant :user

  belongs_to :user

  has_many :tasks, dependent: :destroy

  accepts_nested_attributes_for :tasks, allow_destroy: true
end
