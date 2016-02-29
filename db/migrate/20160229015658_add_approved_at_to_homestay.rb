class AddApprovedAtToHomestay < ActiveRecord::Migration
  def change
    add_column :homestays, :approved_at, :datetime
  end
end
