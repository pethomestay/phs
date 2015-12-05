class AddDisplayAddressToHomestay < ActiveRecord::Migration
  def change
    add_column :homestays, :display_address, :string, limit: 100
  end
end
