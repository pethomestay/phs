class RemoveHostAcceptedFromEnquiries < ActiveRecord::Migration
  def up
	  remove_column :enquiries, :host_accepted
  end

  def down
	  add_column :enquiries, :host_accepted, :boolean, default: false
  end
end
