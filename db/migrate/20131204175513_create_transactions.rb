class CreateTransactions < ActiveRecord::Migration
  def up
	  create_table :transactions do |t|
		  t.references :user
		  t.string :t_id
		  t.string :time_stamp
		  t.string :merchant_fingerprint
		  t.string :preauthid
		  t.string :restext
		  t.string :status, default: TRANSACTION_STATUS_UNFINISHED
		  t.float  :amount
		  t.string :secure_pay_fingerprint

		  t.timestamps
	  end
  end

  def down
		drop_table :transactions
  end
end
