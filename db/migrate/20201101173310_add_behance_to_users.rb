class AddBehanceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :behance, :string
  end
end
