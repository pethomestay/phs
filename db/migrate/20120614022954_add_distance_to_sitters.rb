class AddDistanceToSitters < ActiveRecord::Migration
  def change
    add_column :sitters, :distance, :integer
  end
end
