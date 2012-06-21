class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.references :user
      t.string :name
      t.string :type
      t.string :breed

      t.timestamps
    end
    add_index :pets, :user_id
  end
end
