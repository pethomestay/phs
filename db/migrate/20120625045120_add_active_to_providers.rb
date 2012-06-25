class AddActiveToProviders < ActiveRecord::Migration
  def change
    %w{hotels sitters}.each do |table|
      add_column table, :active, :boolean
    end
  end
end
