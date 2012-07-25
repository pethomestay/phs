class AddBooleansToEnquiries < ActiveRecord::Migration
  def change
    add_column :enquiries, :responded, :boolean
    add_column :enquiries, :accepted, :boolean
  end
end
