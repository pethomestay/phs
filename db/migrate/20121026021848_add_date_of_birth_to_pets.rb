class AddDateOfBirthToPets < ActiveRecord::Migration
  def change
    add_column :pets, :date_of_birth, :date
  end
end
