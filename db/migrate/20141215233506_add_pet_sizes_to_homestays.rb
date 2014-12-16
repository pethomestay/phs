class AddPetSizesToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :pets_sizes, :text
  end
end
