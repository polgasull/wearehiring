class CreateJobPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :job_prices do |t|
      t.string :name
      t.string :internal_name
      t.integer :value
      t.integer :value_with_taxes

      t.timestamps
    end
  end
end
