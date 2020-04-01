class AddJobToAbilities < ActiveRecord::Migration[5.1]
  def change
    add_reference :abilities, :job, foreign_key: true
  end
end
