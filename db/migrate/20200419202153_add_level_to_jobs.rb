class AddLevelToJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :level, foreign_key: true
  end
end
