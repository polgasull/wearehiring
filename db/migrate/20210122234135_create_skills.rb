# frozen_string_literal: true

class CreateSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :skills do |t|
      t.string        :internal_name
      t.string        :name
      t.timestamps
    end
  end
end