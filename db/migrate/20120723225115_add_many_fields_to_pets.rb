class AddManyFieldsToPets < ActiveRecord::Migration
  def change
    add_column :pets, :sex, :string
    add_column :pets, :age, :string
    add_column :pets, :microchip_number, :string
    add_column :pets, :council_number, :string
    add_column :pets, :size, :string
    add_column :pets, :explain_dislikes, :text
    add_column :pets, :other_pet_type, :string
  end
end
