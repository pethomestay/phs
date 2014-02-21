class AddReuseMessageToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :reuse_message, :boolean
  end
end
