class AddDateToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :date, :date
  end
end
