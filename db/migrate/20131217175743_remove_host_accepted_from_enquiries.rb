class RemoveHostAcceptedFromEnquiries < ActiveRecord::Migration
  def self.up
	  remove_column :enquiries, :host_accepted
  end

  def self.down
	  add_column :enquiries, :host_accepted, :boolean, default: false
  end
end
