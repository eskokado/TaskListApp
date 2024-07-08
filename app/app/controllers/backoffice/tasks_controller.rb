module Backoffice
  class TasksController < BackofficeController
    before_action :set_task_list
    before_action :set_task, only: [:show, :edit, :update, :destroy]

    def index
      @tasks = @task_list.tasks
    end

    def show
    end

    def new
      @task = @task_list.tasks.new
    end

    def create
      @task = @task_list.tasks.new(task_params)
      if @task.save
        redirect_to backoffice_task_list_task_path(@task_list, @task), notice: 'Task was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @task.update(task_params)
        redirect_to backoffice_task_list_task_path(@task_list, @task), notice: 'Task was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @task.destroy
      redirect_to backoffice_task_list_tasks_path(@task_list), notice: 'Task was successfully deleted.'
    end

    private

    def set_task_list
      @task_list = TaskList.find(params[:task_list_id])
    end

    def set_task
      @task = @task_list.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :status)
    end
  end
end
