require 'rails_helper'

RSpec.describe TransactionProcessor do
  let(:user) { create :user }
  let(:booking) { create :booking, bookee: user, booker: user, amount: 10 }
  let(:processor) { TransactionProcessor.new(booking) }
  let(:transaction) { build :transaction }

  describe '#initialize' do
    it 'sets transactable' do
      expect(processor.transactable).to eq booking
    end
  end

  describe '#transaction' do
    context 'when transactable has transaction' do
      it 'returns transaction' do
        transaction.update_attributes(booking: booking)
        expect(processor.transaction).to eq transaction
      end
    end

    context 'when transactable has no transaction' do
      it 'creates a new transaction' do
        expect(processor.transaction).to_not eq transaction
        expect(processor.transaction).to be_persisted
      end
    end

    it 'returns a transaction' do
      expect(processor.transaction).to be_an_instance_of Transaction
    end
  end

  describe '#process' do
    before :each do
      transaction.update_attributes(booking: booking)
    end

    it 'saves transaction details' do
      processor.process
      expect(processor.transaction.attributes).to include({
        "reference" => "transaction_id=#{transaction.id}",
        "type_code" => 1,
        "amount" => 10.0,
        "time_stamp" => be_present,
        "merchant_fingerprint" => be_present
      })
    end
  end
end
