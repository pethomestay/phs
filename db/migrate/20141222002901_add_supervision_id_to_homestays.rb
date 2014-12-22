class AddSupervisionIdToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :supervision_id, :integer
  end
end
