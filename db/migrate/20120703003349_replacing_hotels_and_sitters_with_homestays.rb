class ReplacingHotelsAndSittersWithHomestays < ActiveRecord::Migration
  def up
    drop_table :hotels
    drop_table :sitters

    create_table :homestays do |t|
      t.string   :title
      t.integer  :cost_per_night
      t.text     :description
      t.integer  :user_id
      t.string   :address_1
      t.string   :address_2
      t.string   :address_suburb
      t.string   :address_city
      t.string   :address_postcode
      t.string   :address_country
      t.float    :latitude
      t.float    :longitude
      t.boolean  :active
 
      t.timestamps
    end

    add_index :homestays, :user_id

    remove_column :users, :wants_to_be_sitter
    remove_column :users, :wants_to_be_hotel
    remove_column :users, :wants_to_be_professional_hotel

    remove_index :enquiries, [:provider_id, :provider_type]
    remove_column :enquiries, :provider_id
    remove_column :enquiries, :provider_type
    add_column :enquiries, :homestay_id, :integer
    add_index :enquiries, :homestay_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
