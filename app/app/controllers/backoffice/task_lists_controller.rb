module Backoffice
  class TaskListsController < BackofficeController
    protect_from_forgery except: :update
    before_action :set_task_list, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!

    set_current_tenant_through_filter

    before_action :set_tenant

    def index
      @task_lists = TaskList.includes(:tasks).page(params[:page]).per(2)
    end

    def show
    end

    def new
      @task_list = TaskList.new
      @task_list.tasks.build
    end

    def create
      @task_list = TaskList.new(task_list_params)
      @task_list.user = current_user
      if @task_list.save
        redirect_to backoffice_task_list_path(@task_list), notice: 'Task list was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @task_list.update(task_list_params)
        redirect_to backoffice_task_list_path(@task_list), notice: 'Task list was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @task_list.destroy
      redirect_to backoffice_task_lists_url, notice: 'Task list was successfully destroyed.'
    end

    private

    def set_task_list
      @task_list = TaskList.find(params[:id])
    end

    def task_list_params
      params.require(:task_list).permit(:name, tasks_attributes: [:id, :name, :status, :_destroy])
    end

    def set_tenant
      set_current_tenant(current_user)
    end
  end
end
