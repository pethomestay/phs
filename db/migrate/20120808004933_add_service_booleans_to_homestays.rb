class AddServiceBooleansToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :pet_feeding, :boolean, default: false
    add_column :homestays, :pet_grooming, :boolean, default: false
    add_column :homestays, :pet_training, :boolean, default: false
    add_column :homestays, :pet_walking, :boolean, default: false
  end
end
