class AddPetWalkingPriceToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :pet_walking_price, :decimal
  end
end
