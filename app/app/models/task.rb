class Task < ApplicationRecord
  belongs_to :task_list

  validates :name, :status, presence: true

  enum status: {
    pending: 'pending',
    completed: 'completed'
  }

  scope :pending, -> { where(status: 'pending') }
end
