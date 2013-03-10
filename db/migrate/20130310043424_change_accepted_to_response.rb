class ChangeAcceptedToResponse < ActiveRecord::Migration
  def up
    add_column :enquiries, :response_message, :text
    add_column :enquiries, :response_id, :integer, default: 0
    add_index :enquiries, :response_id
    execute "update enquiries set response_id = 1 where responded = false"
    execute "update enquiries set response_id = 2 where responded = true and accepted = true"
    execute "update enquiries set response_id = 4 where responded = true and accepted = false"
    remove_columns :enquiries, :responded, :accepted
  end

  def down
    add_column :enquiries, :responded, :boolean, default: false
    add_column :enquiries, :accepted, :boolean, default: false
    execute "update enquiries set responded = false where response_id = 1"
    execute "update enquiries set responded = true, accepted = true where response_id = 2"
    execute "update enquiries set responded = true and accepted = false where response_id = 4"
    remove_index :enquiries, :response_id
    remove_columns :enquiries, :response_id, :response_message
  end
end
