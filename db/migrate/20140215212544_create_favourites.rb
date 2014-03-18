class CreateFavourites < ActiveRecord::Migration
  def up
	  create_table :favourites do |t|
		  t.belongs_to :user
		  t.belongs_to :homestay

		  t.timestamps
	  end
  end

  def down
		drop_table :favourites
  end
end
