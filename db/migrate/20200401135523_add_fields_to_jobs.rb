class AddFieldsToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :budget, :integer
    add_column :jobs, :open, :boolean
    add_column :jobs, :awarded_proposal, :integer
  end
end
