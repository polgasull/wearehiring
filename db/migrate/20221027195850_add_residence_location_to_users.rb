class AddResidenceLocationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :resident_state, :string
    add_column :users, :resident_country, :string
    add_column :users, :resident_country_code, :string
    add_column :users, :resident_city, :string
    add_column :users, :resident_postal_code, :string
  end
end
