class AddDefaultValueToPetTypeId < ActiveRecord::Migration
  def change
    change_column_default :pets, :pet_type_id, 1
  end
end
