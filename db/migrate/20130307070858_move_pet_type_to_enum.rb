class MovePetTypeToEnum < ActiveRecord::Migration
  def up
    add_column :pets, :pet_type_id, :integer
    execute "update pets set pet_type_id = 1 where pet_type = 'dog'"
    execute "update pets set pet_type_id = 2 where pet_type = 'cat'"
    execute "update pets set pet_type_id = 3 where pet_type = 'bird'"
    execute "update pets set pet_type_id = 4 where pet_type = 'fish'"
    execute "update pets set pet_type_id = 5 where pet_type = 'other'"
    remove_column :pets, :pet_type
  end

  def down
    add_column :pets, :pet_type, :string
    execute "update pets set pet_type = 'dog' where pet_type_id = 1"
    execute "update pets set pet_type = 'cat' where pet_type_id = 2"
    execute "update pets set pet_type = 'bird' where pet_type_id = 3"
    execute "update pets set pet_type = 'fish' where pet_type_id = 4"
    execute "update pets set pet_type = 'other' where pet_type_id = 5"
    remove_column :pets, :pet_type_id
  end
end
