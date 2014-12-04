class AddForCharityToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :for_charity, :boolean, default: false
  end
end
