module Backoffice
  class TaskListsController < BackofficeController
    protect_from_forgery except: :update
    before_action :set_task_list, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!

    def index
      @task_lists = TaskList.includes(:tasks).shared_with_user(current_user).page(params[:page]).per(2)
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
        redirect_to backoffice_task_list_path(@task_list), notice: t('.create')
      else
        render :new
      end
    end

    def edit
    end

    def update
      unless @task_list.user == current_user
        redirect_to backoffice_task_lists_path, alert: t('.alert.access.danied')
        return
      end

      if @task_list.update(task_list_params)
        redirect_to backoffice_task_list_path(@task_list), notice: t('.update')
      else
        render :edit
      end
    end

    def destroy
      unless @task_list.user == current_user
        redirect_to backoffice_task_lists_path, alert: t('.alert.access.danied')
        return
      end

      @task_list.destroy
      redirect_to backoffice_task_lists_url, notice: t('.destroy')
    end

    private

    def set_task_list
      @task_list = TaskList.find(params[:id])
    end

    def task_list_params
      params.require(:task_list).permit(:name, :shared, tasks_attributes: [:id, :name, :status, :_destroy])
    end
  end
end
