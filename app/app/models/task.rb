class Task < ApplicationRecord
  belongs_to :task_list

  enum status: {
    pending: 'pending',
    completed: 'completed'
  }
end
