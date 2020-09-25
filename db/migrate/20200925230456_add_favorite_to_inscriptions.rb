class AddFavoriteToInscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :inscriptions, :favorite, :boolean
  end
end
