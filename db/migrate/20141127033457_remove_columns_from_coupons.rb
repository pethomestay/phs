class RemoveColumnsFromCoupons < ActiveRecord::Migration
  def change
    remove_column :coupons, :booking_id
    remove_column :coupons, :used_by_id
    rename_column :coupons, :referrer_id, :user_id
  end
end
