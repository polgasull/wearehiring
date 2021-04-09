class AddDefaultValueToVisible < ActiveRecord::Migration[5.1]
  def up
    change_column :users, :visible, :boolean, default: true
  end
  
  def down
    change_column :users, :visible, :boolean, default: nil
  end
end
