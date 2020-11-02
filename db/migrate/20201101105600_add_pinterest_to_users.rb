class AddPinterestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pinterest, :string
  end
end
