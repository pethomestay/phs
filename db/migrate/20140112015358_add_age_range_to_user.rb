class AddAgeRangeToUser < ActiveRecord::Migration
  def change
    add_column :users, :age_range_min, :integer
    add_column :users, :age_range_max, :integer
  end
end
