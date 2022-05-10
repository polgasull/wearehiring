class AddJobPriceToJobs < ActiveRecord::Migration[7.0]
  def change
    add_reference :jobs, :job_price, foreign_key: true
  end
end
