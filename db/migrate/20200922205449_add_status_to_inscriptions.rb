class AddStatusToInscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :inscriptions, :status, :integer
  end
end
