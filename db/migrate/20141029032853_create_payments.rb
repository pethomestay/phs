class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :booking_id
      t.string :status
      t.decimal :amount
      t.string :braintree_token
      t.boolean :paid_to_host

      t.timestamps
    end
  end
end
