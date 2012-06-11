class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :stars
      t.text :review
      t.references :user
      t.integer :ratable_id
      t.string :ratable_type

      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, [:ratable_id, :ratable_type]
  end
end
