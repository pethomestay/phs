class AddDoubleConfirmationToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :confirmed, :boolean, default: false
    add_column :enquiries, :owner_accepted, :boolean, default: false
  end
end
