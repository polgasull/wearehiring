class AddTagToTaggings < ActiveRecord::Migration[5.1]
  def change
    add_reference :taggings, :tag, foreign_key: true
  end
end
