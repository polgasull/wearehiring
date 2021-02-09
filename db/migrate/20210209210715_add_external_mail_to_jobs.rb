class AddExternalMailToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :external_mail, :string, null: false, default: ""
  end
end
