class AddSkillToAbilities < ActiveRecord::Migration[5.1]
  def change
    add_reference :abilities, :skill, foreign_key: true
  end
end
