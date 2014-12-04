class RemoveCouponCodeFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :coupon_code
  end

  def down
    add_column :users, :coupon_code, :string
  end
end
