class RenameDurationOnEnquiries < ActiveRecord::Migration
  def change
    rename_column :enquiries, :max_number_of_days, :duration
  end
end
