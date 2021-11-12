class AddDiscountCodeToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :discount_code, :string
  end
end
