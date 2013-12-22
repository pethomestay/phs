class AddHostAcceptedToEnquiries < ActiveRecord::Migration
  def up
		add_column :enquiries, :host_accepted, :boolean, default: false
  end

	def down
		remove_column :enquiries, :host_accepted
	end
end
