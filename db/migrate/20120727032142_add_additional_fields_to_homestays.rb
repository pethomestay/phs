class AddAdditionalFieldsToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :constant_supervision, :boolean, default: false
    add_column :homestays, :emergency_transport, :boolean, default: false
    add_column :homestays, :first_aid, :boolean, default: false
    add_column :homestays, :insurance, :boolean, default: false
    add_column :homestays, :professional_qualification, :boolean, default: false
    add_column :homestays, :professional_qualification_detail, :string
    add_column :homestays, :years_looking_after_pets, :string
    add_column :homestays, :website, :string
    add_column :homestays, :pets_present, :boolean, default: false
  end
end
