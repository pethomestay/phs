class AddBooleanDefaults < ActiveRecord::Migration
  def up
    change_column_default :pets, :flea_treated, false
    change_column_default :pets, :vaccinated, false
    change_column_default :pets, :house_trained, false
  end

  def down
  end
end
