class AddJobToTaggings < ActiveRecord::Migration[5.1]
  def change
    add_reference :taggings, :job, foreign_key: true
  end
end
