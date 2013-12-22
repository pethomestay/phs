class CreateTransactions < ActiveRecord::Migration
	def up
		create_table :transactions do |t|
			t.references :booking
			t.string :transaction_id
			t.string :time_stamp
			t.string :merchant_fingerprint
			t.string :pre_authorisation_id
			t.string :response_text
			t.integer :amount
			t.string :secure_pay_fingerprint
			t.string :reference
			t.string :type_code

			t.timestamps
		end
	end

	def down
		drop_table :transactions
	end
end