class CreateHotelsAndHomestays < ActiveRecord::Migration
  def change
    %w{hotels sitters}.each do |table|
      create_table table do |t|
        t.string :title
        t.string :location
        t.integer :price
        t.text :description
        t.timestamps
      end
    end
  end
end
