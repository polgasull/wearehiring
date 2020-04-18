class AddFieldsToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :salary_from, :integer
    add_column :jobs, :salary_to, :integer
    add_column :jobs, :open, :boolean
  end
end
