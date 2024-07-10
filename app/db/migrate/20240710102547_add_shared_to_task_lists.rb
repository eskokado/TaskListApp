class AddSharedToTaskLists < ActiveRecord::Migration[7.1]
  def change
    add_column :task_lists, :shared, :boolean
  end
end
