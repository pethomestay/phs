class ChangeDefaultValueOfPetAttributes < ActiveRecord::Migration
  def up
    change_column_default :pets, :flea_treated,  true
    change_column_default :pets, :vaccinated,    true
    change_column_default :pets, :house_trained, true
  end

  def down
    change_column_default :pets, :flea_treated,  false
    change_column_default :pets, :vaccinated,    false
    change_column_default :pets, :house_trained, false
  end
end
