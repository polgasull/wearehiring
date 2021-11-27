class AddPartnerToJobs < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :partner, foreign_key: true
  end
end
