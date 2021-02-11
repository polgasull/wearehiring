# frozen_string_literal: true

class CreateJobSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :job_skills do |t|
      t.belongs_to :job
      t.belongs_to :skill
      t.timestamps
    end
  end
end
