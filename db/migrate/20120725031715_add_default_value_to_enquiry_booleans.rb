class AddDefaultValueToEnquiryBooleans < ActiveRecord::Migration
  def up
      change_column :enquiries, :accepted, :boolean, :default => false
      change_column :enquiries, :responded, :boolean, :default => false
  end

  def down
      change_column :enquiries, :accepted, :boolean, :default => nil
      change_column :enquiries, :responded, :boolean, :default => nil
  end
end
