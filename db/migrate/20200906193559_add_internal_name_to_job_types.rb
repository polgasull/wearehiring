class AddInternalNameToJobTypes < ActiveRecord::Migration[5.1]
  def change
    add_column :job_types, :internal_name, :string
  end
end
