class AddAdminMassCodeToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :admin_mass_code, :boolean, :default => false
  end
end
