class ChangeDefaultValueForOpenJobs < ActiveRecord::Migration[5.1]
  def change
    change_column_default :jobs, :open, from: nil, to: true
  end
end
