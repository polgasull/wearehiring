class AddJobToInscriptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :inscriptions, :job, foreign_key: true
  end
end
