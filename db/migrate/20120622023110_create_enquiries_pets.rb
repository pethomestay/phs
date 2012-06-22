class CreateEnquiriesPets < ActiveRecord::Migration
  def change
    create_table :enquiries_pets do |t|
      t.column :enquiry_id, :integer
      t.column :pet_id, :integer
    end
    add_index :enquiries_pets, :enquiry_id
    add_index :enquiries_pets, :pet_id
  end
end
