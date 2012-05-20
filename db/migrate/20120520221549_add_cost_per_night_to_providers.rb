class AddCostPerNightToProviders < ActiveRecord::Migration
  def change
    %w{hotels sitters}.each do |table|
      add_column table, :cost_per_night, :integer
    end
  end
end
