class AddTaggedToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :tagged, :boolean
  end
end
