class AddMaxNumberOfDaysToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :max_number_of_days, :string
  end
end
