class ChangeCurrencyToFloat < ActiveRecord::Migration
  def up
		change_table :transactions do |t|
			t.change :amount, :float
		end

		change_table :bookings do |t|
			t.change :subtotal, :float
			t.change :amount, :float
			t.change :cost_per_night, :float
		end

		change_table :homestays do |t|
			t.change :cost_per_night, :float
		end
  end

  def down
	  change_table :transactions do |t|
		  t.change :amount, :integer
	  end

	  change_table :bookings do |t|
		  t.change :subtotal, :integer
		  t.change :amount, :integer
		  t.change :cost_per_night, :integer
	  end

	  change_table :homestays do |t|
		 t.change :cost_per_night, :integer
	  end
  end
end
