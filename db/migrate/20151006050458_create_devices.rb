class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :user
      t.string :name, limit: 100
      t.string :token, limit: 64
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :devices, :user_id
    add_index :devices, :token
  end
end
