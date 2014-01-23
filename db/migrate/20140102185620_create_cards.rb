class CreateCards < ActiveRecord::Migration
  def up
	  create_table :cards do |t|
		  t.belongs_to :user
		  t.string :card_number
		  t.string :token

		  t.timestamps
	  end
  end

  def down
		drop_table :cards
  end
end
