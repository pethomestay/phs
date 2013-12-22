class AddCheckInCheckOutToEnquiries < ActiveRecord::Migration
  def up
		remove_column :enquiries, :date
		add_column :enquiries, :check_in_date, :date
		add_column :enquiries, :check_in_time, :time
		add_column :enquiries, :check_out_date, :date
		add_column :enquiries, :check_out_time, :time
  end

  def down
	  remove_column :enquiries, :check_in_date
	  remove_column :enquiries, :check_in_time
	  remove_column :enquiries, :check_out_date
	  remove_column :enquiries, :check_out_time
	  add_column :enquiries, :date, :date
  end
end
