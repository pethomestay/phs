class ChangeCostPerNightColumnToDecimal < ActiveRecord::Migration
  def up
    change_column :bookings, :cost_per_night, :decimal
    change_column :bookings, :amount, :decimal
    change_column :bookings, :refund, :decimal
    change_column :bookings, :subtotal, :decimal
    change_column :homestays, :cost_per_night, :decimal
  end

  def down
    raise ActiveRecord::IrreversibleMigration # Prevents this from being reverted
  end
end
