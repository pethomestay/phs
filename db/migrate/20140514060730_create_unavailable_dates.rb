class CreateUnavailableDates < ActiveRecord::Migration
  def change
    create_table :unavailable_dates do |t|
      t.date :date
      t.references :user

      t.timestamps
    end
    add_index :unavailable_dates, :user_id
  end
end
