class AddMedicalAndEmergencyDetailsToPets < ActiveRecord::Migration
  def change
    add_column :pets, :emergency_contact_name, :string
    add_column :pets, :emergency_contact_phone, :string
    add_column :pets, :vet_name, :string
    add_column :pets, :vet_phone, :string
    add_column :pets, :medication, :text
  end
end
