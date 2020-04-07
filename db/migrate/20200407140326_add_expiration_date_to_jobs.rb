class AddExpirationDateToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :expiry_date, :datetime
  end
end
