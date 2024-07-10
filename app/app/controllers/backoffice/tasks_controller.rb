module Backoffice
  class TasksController < BackofficeController
    before_action :set_task_list
    before_action :set_task, only: [:show, :edit, :update, :destroy, :mark_as_done, :purge_attachment]
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
      if @task.update(task_params.except(:files))
        @task.files.attach(task_params[:files]) if task_params[:files].present?
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

    def purge_attachment
      attachment = ActiveStorage::Attachment.find(params[:attachment_id])
      attachment.purge

      referer_path = URI(request.referer).path

      if referer_path.include?("edit")
        redirect_to edit_backoffice_task_list_task_path(@task_list, @task), notice: t('.notice.remove.success')
      else
        redirect_to backoffice_task_list_task_path(@task_list, @task), notice: t('.notice.remove.success')
      end
    end

    private

    def set_task_list
      @task_list = TaskList.find(params[:task_list_id])
    end

    def set_task
      @task = Task.find(params[:id])
    end

    def task_params
      params.require(:task).permit(:name, :status, files: [])
    end
  end
end
