class AddFavoriteBreedsToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :favorite_breeds, :text
  end
end
