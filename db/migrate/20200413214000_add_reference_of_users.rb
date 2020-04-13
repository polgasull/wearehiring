class AddReferenceOfUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :jobs, :user, foreign_key: true
    add_reference :inscriptions, :user, foreign_key: true
  end
end
