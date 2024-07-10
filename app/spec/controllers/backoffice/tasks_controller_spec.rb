# spec/controllers/backoffice/tasks_controller_spec.rb
require 'rails_helper'

RSpec.describe Backoffice::TasksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:task_list) { FactoryBot.create(:task_list, user: user) }
  let(:task) { FactoryBot.create(:task, task_list: task_list) }

  before(:each) do
    allow_any_instance_of(BackofficeController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { task_list_id: task_list.id, id: task.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: { task_list_id: task_list.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { FactoryBot.attributes_for(:task, task_list_id: task_list.id) }

      it 'creates a new Task' do
        expect {
          post :create, params: { task_list_id: task_list.id, task: valid_attributes }
        }.to change(Task, :count).by(1)
      end

      it 'redirects to the created task' do
        post :create, params: { task_list_id: task_list.id, task: valid_attributes }
        expect(response).to redirect_to(backoffice_task_list_task_path(task_list, Task.last))
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { FactoryBot.attributes_for(:task, name: nil, task_list_id: task_list.id) }

      it 'does not create a new Task' do
        expect {
          post :create, params: { task_list_id: task_list.id, task: invalid_attributes }
        }.to_not change(Task, :count)
      end

      it 'renders the new template' do
        post :create, params: { task_list_id: task_list.id, task: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { task_list_id: task_list.id, id: task.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { name: 'Updated Name' } }

    context 'with valid params' do
      it 'updates the requested task' do
        patch :update, params: { task_list_id: task_list.id, id: task.id, task: new_attributes }
        task.reload
        expect(task.name).to eq('Updated Name')
      end

      it 'redirects to the task' do
        patch :update, params: { task_list_id: task_list.id, id: task.id, task: new_attributes }
        expect(response).to redirect_to(backoffice_task_list_task_path(task_list, task))
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { name: '' } }

      it 'does not update the task' do
        patch :update, params: { task_list_id: task_list.id, id: task.id, task: invalid_attributes }
        task.reload
        expect(task.name).to_not eq('')
      end

      it 'renders the edit template' do
        patch :update, params: { task_list_id: task_list.id, id: task.id, task: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      task # Ensure task is created before expecting it to be destroyed
      expect {
        delete :destroy, params: { task_list_id: task_list.id, id: task.id }
      }.to change(Task, :count).by(-1)
    end

    it 'redirects to the task_list' do
      delete :destroy, params: { task_list_id: task_list.id, id: task.id }
      expect(response).to redirect_to(backoffice_task_list_path(task_list))
    end
  end

  describe 'PATCH #mark_as_done' do
    it 'updates the task status' do
      patch :mark_as_done, params: { task_list_id: task_list.id, id: task.id, status: 'completed' }
      task.reload
      expect(task.status).to eq('completed')
    end

    it 'redirects to the task list with notice on success' do
      patch :mark_as_done, params: { task_list_id: task_list.id, id: task.id, status: 'completed' }
      expect(response).to redirect_to(backoffice_task_list_path(task_list))
      expect(flash[:notice]).to eq(I18n.t('backoffice.tasks.status_updated'))
    end
  end
end
