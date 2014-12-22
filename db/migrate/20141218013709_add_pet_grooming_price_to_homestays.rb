class AddPetGroomingPriceToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :pet_grooming_price, :decimal
  end
end
