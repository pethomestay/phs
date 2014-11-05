class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :booking
  
  attr_accessible :amount, :booking_id, :braintree_token, :status, :user_id, :paid_to_host
  validates_uniqueness_of :braintree_token

  after_save :notify_parties

  def notify_parties
    self.booking.host_accepted? ? ProviderMailer.booking_made(self.booking).deliver : ProviderMailer.owner_confirmed(self.booking).deliver
    PetOwnerMailer.booking_receipt(self.booking).deliver
    PetOwnerMailer.booking_confirmation(self.booking).deliver if self.booking.host_accepted
  end
end
