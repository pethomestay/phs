class RemoveTaggedFromEnquiry < ActiveRecord::Migration
  def up
    remove_column :enquiries, :tagged
  end

  def down
    add_column :enquiries, :tagged, :boolean
  end
end
