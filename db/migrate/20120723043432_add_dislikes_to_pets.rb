class AddDislikesToPets < ActiveRecord::Migration
  def change
    add_column :pets, :dislike_loneliness, :boolean
    add_column :pets, :dislike_children, :boolean
    add_column :pets, :dislike_animals, :boolean
    add_column :pets, :dislike_people, :boolean
  end
end
