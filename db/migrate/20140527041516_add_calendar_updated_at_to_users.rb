class AddCalendarUpdatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :calendar_updated_at, :date
  end
end
