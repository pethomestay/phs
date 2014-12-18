class AddRemotePriceToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :remote_price, :decimal
  end
end
