class AddMetaTitleToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :meta_title, :string
  end
end
