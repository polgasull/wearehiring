class AddInternalNameToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :internal_name, :string
  end
end
