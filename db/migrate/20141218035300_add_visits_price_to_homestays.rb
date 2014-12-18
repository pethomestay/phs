class AddVisitsPriceToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :visits_price, :decimal
  end
end
