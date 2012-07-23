class AddBooleansToPets < ActiveRecord::Migration
  def change
    add_column :pets, :flea_treated, :boolean
    add_column :pets, :vaccinated, :boolean
    add_column :pets, :house_trained, :boolean
  end
end
