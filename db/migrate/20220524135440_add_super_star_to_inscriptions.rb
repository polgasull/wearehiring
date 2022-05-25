class AddSuperStarToInscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :inscriptions, :super_star, :boolean, default: false
  end
end
