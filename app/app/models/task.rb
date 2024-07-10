class Task < ApplicationRecord
  belongs_to :task_list
  has_many_attached :files

  validates :name, :status, presence: true

  validate :files_must_be_images_or_pdfs

  enum status: {
    pending: 'pending',
    completed: 'completed'
  }

  scope :pending, -> { where(status: 'pending') }

  private

  def files_must_be_images_or_pdfs
    files.each do |file|
      unless file.content_type.in?(%w[image/jpeg image/png application/pdf])
        errors.add(:files, 'must be an image or a PDF')
      end
    end
  end
end
