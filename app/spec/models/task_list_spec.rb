# spec/models/task_list_spec.rb
require 'rails_helper'

RSpec.describe TaskList, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for tasks' do
      attributes = attributes_for(:task_list).merge(
        tasks_attributes: [attributes_for(:task)]
      )
      task_list = TaskList.new(attributes)
      expect(task_list.tasks.size).to eq(1)
    end
  end

  describe 'scopes' do
    describe '.shared_with_user' do
      it 'includes task lists shared with the user' do
        shared_task_list = create(:task_list, :shared, user: another_user)
        own_task_list = create(:task_list, user: user)

        expect(TaskList.shared_with_user(user)).to include(shared_task_list, own_task_list)
      end

      it 'does not include task lists not shared with the user' do
        not_shared_task_list = create(:task_list, user: another_user)

        expect(TaskList.shared_with_user(user)).not_to include(not_shared_task_list)
      end
    end
  end
end
