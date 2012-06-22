class CreateEnquiries < ActiveRecord::Migration
  def change
    create_table :enquiries do |t|
      t.references :user
      t.integer :provider_id
      t.string :provider_type

      t.timestamps
    end
    add_index :enquiries, :user_id
    add_index :enquiries, [:provider_id, :provider_type]
  end
end
