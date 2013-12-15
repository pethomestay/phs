class AddHostAcceptedToEnquiries < ActiveRecord::Migration
  def self.up
		add_column :enquiries, :host_accepted, :boolean, default: false
  end

	def self.down
		remove_column :enquiries, :host_accepted
	end
end
