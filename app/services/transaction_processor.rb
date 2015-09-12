class TransactionProcessor
  # This processor refers to transactions done by booking
  # Should other scenarios arise, extend/subclass this processor to fit the scenario
  attr_reader :transactable

  # Create a TransactionProcessor
  #
  # @api public
  # @return [TransactionProcessor]
  def initialize(transactable)
    # Transactable refers to objects that can transact, in this case, booking
    @transactable = transactable
  end

  # Return transaction
  #
  # @api public
  # @return [Transaction]
  def transaction
    @transaction ||= transactable.transaction || Transaction.create(booking_id: transactable.id)
  end

  # Process transaction
  #
  # @api public
  # @return [Boolean]
  def process
    transaction.update_attributes transaction_params
  end

  private

  # Create finger print
  #
  # @api private
  # @return [String]
  def fingerprint
    "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{transaction.type_code}|#{transaction.
        reference}|#{transaction.actual_amount}|#{transaction.time_stamp}"
  end

  # Prepare transaction params
  #
  # @api private
  # @return [Hash]
  def transaction_params
    {
      reference: "transaction_id=#{transaction.id}",
      type_code: 1, # preauth type is 1, simple transaction type is 0
      amount: transactable.amount,
      time_stamp: Time.now.gmtime.strftime("%Y%m%d%H%M%S"),
      merchant_fingerprint: Digest::SHA1.hexdigest(fingerprint)
    }
  end

end
