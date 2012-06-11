class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :file_uid
      t.integer :picturable_id
      t.string :picturable_type

      t.timestamps
    end
  end
end
