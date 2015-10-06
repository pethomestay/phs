class SetDefaultValueToPet < ActiveRecord::Migration
  def change
    change_column :pets, :energy_level, :integer, :default => 3
    change_column :pets, :size_id,      :integer, :default => 1
    change_column :pets, :age,          :string,  :default => "5"
  end
end
