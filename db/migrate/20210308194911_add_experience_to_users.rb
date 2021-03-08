class AddExperienceToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :experience, :string
  end
end
