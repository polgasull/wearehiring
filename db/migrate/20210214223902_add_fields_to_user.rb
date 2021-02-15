class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :salary_from, :integer
    add_column :users, :salary_to, :integer
    add_column :users, :visible, :boolean
  end
end
