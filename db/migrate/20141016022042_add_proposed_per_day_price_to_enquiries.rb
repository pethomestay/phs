class AddProposedPerDayPriceToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :proposed_per_day_price, :decimal
  end
end
