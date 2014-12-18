class FixPetsSizes < ActiveRecord::Migration
  def change
    rename_column :homestays, :pets_sizes, :pet_sizes
  end
end
