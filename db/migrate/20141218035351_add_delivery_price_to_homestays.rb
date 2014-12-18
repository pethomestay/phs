class AddDeliveryPriceToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :delivery_price, :decimal
  end
end
