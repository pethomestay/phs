class AddVisitsRadiusToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :visits_radius, :integer
  end
end
