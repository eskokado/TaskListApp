module Backoffice
  class TasksController < BackofficeController
    before_action :set_task_list
    before_action :set_task, only: [:show, :edit, :update, :destroy, :mark_as_done]

    def show
    end

    def new
      @task = @task_list.tasks.new
    end

    def create
      @task = @task_list.tasks.new(task_params)
      if @task.save
        redirect_to backoffice_task_list_task_path(@task_list, @task), notice: t('.create')
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @task.update(task_params)
        redirect_to backoffice_task_list_task_path(@task_list, @task), notice: t('.update')
      else
        render :edit
      end
    end

    def destroy
      @task.destroy
      redirect_to backoffice_task_list_path(@task_list), notice: t('.destroy')
    end

    def mark_as_done
      new_status = params[:status] == 'completed' ? 'completed' : 'pending'
      if @task.update(status: new_status)
        redirect_to backoffice_task_list_path(@task_list), notice: t('.status_updated')
      else
        redirect_to backoffice_task_list_path(@task_list), alert: t('.status_failed')
      end
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
