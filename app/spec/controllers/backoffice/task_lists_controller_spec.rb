# spec/controllers/backoffice/task_lists_controller_spec.rb
require 'rails_helper'

RSpec.describe Backoffice::TaskListsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:task_list) { FactoryBot.create(:task_list, user: user) }

  before(:each) do
    allow_any_instance_of(BackofficeController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns @task_lists' do
      get :index
      expect(assigns(:task_lists)).to_not be_nil
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: task_list.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { FactoryBot.attributes_for(:task_list, user: user) }

      it 'creates a new TaskList' do
        expect {
          post :create, params: { task_list: valid_attributes }
        }.to change(TaskList, :count).by(1)
      end

      it 'redirects to the created task_list' do
        post :create, params: { task_list: valid_attributes }
        expect(response).to redirect_to(backoffice_task_list_path(TaskList.last))
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { FactoryBot.attributes_for(:task_list, name: nil, user: user) }

      it 'does not create a new TaskList' do
        expect {
          post :create, params: { task_list: invalid_attributes }
        }.to_not change(TaskList, :count)
      end

      it 'renders the new template' do
        post :create, params: { task_list: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: { id: task_list.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { name: 'Updated Name' } }

    context 'with valid params' do
      it 'updates the requested task_list' do
        patch :update, params: { id: task_list.id, task_list: new_attributes }
        task_list.reload
        expect(task_list.name).to eq('Updated Name')
      end

      it 'redirects to the task_list' do
        patch :update, params: { id: task_list.id, task_list: new_attributes }
        expect(response).to redirect_to(backoffice_task_list_path(task_list))
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { name: '' } }

      it 'does not update the task_list' do
        patch :update, params: { id: task_list.id, task_list: invalid_attributes }
        task_list.reload
        expect(task_list.name).to_not eq('')
      end

      it 'renders the edit template' do
        patch :update, params: { id: task_list.id, task_list: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task_list' do
      task_list # Ensure task_list is created before expecting it to be destroyed
      expect {
        delete :destroy, params: { id: task_list.id }
      }.to change(TaskList, :count).by(-1)
    end

    it 'redirects to the task_lists list' do
      delete :destroy, params: { id: task_list.id }
      expect(response).to redirect_to(backoffice_task_lists_url)
    end
  end
end
