# spec/models/task_spec.rb
require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task_list) { create(:task_list) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }

    it 'validates that files are images or PDFs' do
      valid_file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'valid_image.png'), 'image/jpeg')
      invalid_file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'invalid_file.txt'), 'text/plain')

      task = build(:task, task_list: task_list)
      task.files.attach(valid_file)
      expect(task).to be_valid

      task.files.attach(invalid_file)
      expect(task).not_to be_valid
      expect(task.errors[:files]).to include('must be an image or a PDF')
    end
  end

  describe 'associations' do
    it { should belong_to(:task_list) }
    it { should have_many_attached(:files) }
  end

  describe 'scopes' do
    it 'returns only pending tasks' do
      pending_task = create(:task, status: 'pending', task_list: task_list)
      completed_task = create(:task, status: 'completed', task_list: task_list)

      expect(Task.pending).to include(pending_task)
      expect(Task.pending).not_to include(completed_task)
    end
  end

  describe 'enums' do
    it 'has the correct enum values for status' do
      expect(Task.statuses).to eq({'pending' => 'pending', 'completed' => 'completed'})
    end
  end
end
