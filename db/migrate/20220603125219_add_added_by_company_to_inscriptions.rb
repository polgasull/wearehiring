class AddAddedByCompanyToInscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :inscriptions, :added_by_company, :boolean, default: false
  end
end
