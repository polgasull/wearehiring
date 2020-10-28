class AddCustomUrlToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :custom_url, :string
  end
end
