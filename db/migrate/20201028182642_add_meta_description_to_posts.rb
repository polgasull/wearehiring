class AddMetaDescriptionToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :meta_description, :string
  end
end
