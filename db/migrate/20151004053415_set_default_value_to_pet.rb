class SetDefaultValueToPet < ActiveRecord::Migration
  def change
    change_column :pets, :energy_level, :string,  :limit => 255, :default => "3"
    change_column :pets, :size_id,      :integer, :default => 1
    change_column :pets, :age,          :string,  :limit => 255, :default => "5"
  end
end
