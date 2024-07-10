# frozen_string_literal: true
class TaskList < ApplicationRecord
  validates :name, presence: true

  belongs_to :user

  has_many :tasks, dependent: :destroy

  accepts_nested_attributes_for :tasks, allow_destroy: true

  scope :shared_with_user, ->(user) do
    where('(shared = ? AND user_id <> ?) OR (user_id = ?)', true, user.id, user.id)
  end
end
