class AddPersonalitiesToPets < ActiveRecord::Migration
  def change
    add_column :pets, :personalities, :text, default: []
  end
end
