class AddIsProfessionalToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :is_professional, :boolean, default: false
  end
end
