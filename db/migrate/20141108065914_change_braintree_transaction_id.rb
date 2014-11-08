class ChangeBraintreeTransactionId < ActiveRecord::Migration
  def change
    change_column :payments, :braintree_transaction_id, :string
  end
end
