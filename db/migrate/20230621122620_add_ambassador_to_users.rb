class AddAmbassadorToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :ambassador, :boolean, default: false
  end
end
