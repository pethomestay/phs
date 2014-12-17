class RemoveCalendarUpdatedAtFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :calendar_updated_at
  end

  def down
    add_column :users, :calendar_updated_at, :date
  end
end
