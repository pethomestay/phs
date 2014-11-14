class AddBraintreeTransactionIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :braintree_transaction_id, :integer
  end
end
