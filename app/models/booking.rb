require 'digest/sha1'

class Booking < ActiveRecord::Base
  belongs_to :booker, class_name: 'User', foreign_key: :booker_id
  belongs_to :bookee, class_name: 'User', foreign_key: :bookee_id
  belongs_to :homestay
  belongs_to :enquiry
  has_one    :coupon_usage
  has_one    :coupon, :through => :coupon_usage

  MINIMUM_DAILY_PRICE = 10.0
  CREDIT_CARD_SURCHARGE_IN_DECIMAL = 0.0 # 2.5% = 0.025
  PER_NIGHT_LIABILITY_INSURANCE_COST = 0 # Modify this to change insurance cost per night

  @@valid_host_view_booking_states_list  = [:finished, :finished_host_accepted, :host_paid, :rejected, :host_requested_cancellation, :host_cancelled, :guest_cancelled]

  has_one :transaction, dependent: :destroy
  has_one :payment
  has_one :mailbox, dependent: :destroy

  validates_presence_of :bookee_id, :booker_id, :check_in_date, :check_out_date
  validate :check_out_date_is_not_less_than_check_in_date, if: "check_in_date && check_out_date"
  validate :is_above_minimum_daily_rate
  validate :subtotal, :presence => true
  #validate :is_host_available_btw_check_in_and_check_out_date, if: "check_in_date && check_out_date"

  attr_accessor :fees, :public_liability_insurance, :phs_service_charge, :host_payout, :pet_breed, :pet_age,
                :pet_date_of_birth

  scope :booked, where(owner_accepted: true, host_accepted: true)

  scope :needing_host_confirmation, where(owner_accepted: true, host_accepted: false, response_id: 0, state: :finished)

  scope :declined_by_host, where(response_id: 6, host_accepted: false)

  scope :required_response, where(response_id: 7, host_accepted: false)

  scope :accepted_by_host, where(response_id: 5, host_accepted: true)

  scope :guest_cancelled, where(:state=>:guest_cancelled).order('created_at DESC')

  scope :finished_and_host_accepted, where(:state=> :finished_host_accepted).order('created_at DESC')

  scope :unfinished, where('state IN (?)', [:unfinished, :payment_authorisation_pending]).order('created_at DESC')


  scope :valid_host_view_booking_states, where('state IN (?)', @@valid_host_view_booking_states_list).order('created_at DESC')

  scope :finished_and_host_accepted_or_host_paid, where('state IN (?)', [:finished_host_accepted, :host_paid]).order('created_at DESC')

  scope :finished_or_host_accepted, where('state IN (?)', [:finished, :finished_host_accepted, :host_paid]).order('created_at DESC')

  after_create :create_mailbox
  after_save   :trigger_host_accept, if: proc {|booking| booking.owner_accepted && booking.try(:payment) && booking.host_accepted == true}
  before_save  :update_state

  def is_above_minimum_daily_rate
    errors.add(:subtotal, 'must be at least $10/night') if self.cost_per_night < MINIMUM_DAILY_PRICE
  end

  def create_mailbox
    mailbox = nil
    if self.enquiry_id.blank?
      mailbox = Mailbox.find_or_create_by_booking_id self.id
    else
      mailbox = Mailbox.find_or_create_by_enquiry_id self.enquiry_id
    end
    mailbox.update_attributes! booking_id: self.id, enquiry_id: self.enquiry_id, guest_mailbox_id: self.booker_id,
                               host_mailbox_id: self.bookee_id
    mailbox.reload
  end

  def update_state
    booking_state = "unfinished"
    booking_state = "finished_host_accepted" if self.host_accepted && self.owner_accepted && self.payment.present?
    booking_state = "finished" if self.host_accepted && (self.payment.present? || self.transaction.present?) && self.owner_accepted != true
    booking_state = "payment_authorisation_pending" if self.host_accepted && self.owner_accepted && (self.transaction.nil? && self.payment.nil?)
    booking_state = "host_cancelled" if ((self.cancel_date.present? && self.cancel_reason == "Admin cancelled") || (self.owner_accepted && self.host_accepted == false))
    booking_state = "guest_cancelled" if self.cancel_date.present? && self.cancel_reason != "Admin cancelled"
    self.state    = booking_state
    return true
  end

  def is_host_view_valid?
   not [:unfinished, :payment_authorisation_pending].include?(self.state.to_sym)
  end

  def refund_payment(guest_cancel = false)
    return if self.payment.nil?
    return if self.check_out_date < Date.today
    if self.payment.status == "authorized"
      result = Braintree::Transaction.void(self.payment.braintree_transaction_id)
    end
    if self.payment.status == "submitted_for_settlement"
      amount = self.calculate_payment_refund
      result = Braintree::Transaction.refund(self.payment.braintree_transaction_id, amount)
      result = Braintree::Transaction.void(self.payment.braintree_transaction_id) unless result.success?
    end
    if result.success?
      self.refund        = amount || self.payment.amount
      self.cancel_reason = self.cancel_reason || "Admin cancelled"
      self.cancel_date = Date.today
      self.save
    else
      raise
      Raygun.track_exception(Exception.new("Refund failed, booking_id:#{self.id}"))
    end
    if guest_cancel
      GuestCancelledBookingHostJob.new.async.perform(self.id) #Let the host know booking has been cancelled
      GuestCancelledBookingGuestJob.new.async.perform(self.id) #Confirm for the guest that their booking has been cancelled
    end
    return result
  end

  def calculate_payment_refund
    return if self.payment.nil?
    days = self.check_in_date.mjd - Date.today.mjd
    days > 14 ? self.payment.amount : days >= 0 ? self.payment.amount * 0.5 : 0
  end

  def unfinished_booking?
    self.state?(:unfinished) or self.state?(:payment_authorisation_pending)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << [
        'Guest name', 'Guest address', 'Pet name', 'Pet breed', 'Pet age', 'Check-in Date', 'Check-in Time',
        'Check-out Date', 'Check-out Time', 'Host name', 'Homestay Title', 'Host Address', '# of 24 hour period',
        'Transaction Reference', 'Total', 'Insurance Fees', 'PHS Fee', 'Host Payout','Status'
      ]

      all.each do |booking|
        booker = booking.booker
        pet = booker.pet
        host = booking.bookee
        booking_reference = booking.transaction.present? ? booking.transaction.reference.to_s : booking.payment.braintree_transaction_id
        booking_payment_amount = booking.transaction.present? ? "$#{booking.transaction.amount}" : "$#{booking.payment.amount.to_s}"
        csv << [
          booker.name.capitalize, booker.complete_address, pet.name, pet.breed, pet.age,
          booking.check_in_date.to_formatted_s(:year_month_day), booking.check_in_time.strftime("%H:%M"),
          booking.check_out_date.to_formatted_s(:year_month_day), booking.check_out_time.strftime("%H:%M"),
          host.name.capitalize, booking.homestay.nil? ? "" : booking.homestay.title, host.complete_address, booking.number_of_nights,
          booking_reference, booking_payment_amount, "$#{booking.public_liability_insurance}",
          "$#{booking.phs_service_charge}", "$#{booking.host_payout}",
          (booking.state?(:host_paid)) ? 'Paid' : 'Not Paid'
        ]
      end
    end
  end

  def self.canceled_states
    [:host_requested_cancellation, :host_cancelled, :guest_cancelled]
  end

  def get_days_left
    return self.check_in_date.mjd - Date.today.mjd
  end

  def get_days_before_cancellation
    return self.check_in_date.mjd - self.cancel_date.mjd
  end

  # More than 14 days away, all of the fee is returned.
  # Between 14 - 7 days, 50% of the fee is returned
  # Less than 7 days, no fee is returned.
  def calculate_refund
    days = get_days_left
    if days > 14
      return self.subtotal - self.phs_service_charge
    elsif days >= 7
      return (self.subtotal - self.phs_service_charge) * 0.5
    else
      return 0
    end
  end

  def amount_minus_fees
    self.subtotal - self.phs_service_charge
  end

  def calculate_host_amount_after_guest_cancel
    days = get_days_left
    if days > 14
      return "0.00"
    elsif days >= 7
      return actual_value_figure(transaction_mode_value(self.amount_minus_fees * 0.5))
    else
      return actual_value_figure(transaction_mode_value(amount_minus_fees))
    end
  end

  state_machine :initial => :unfinished do
    event :host_was_paid do
      transition :finished_host_accepted => :host_paid
    end

    event :host_rejects_booking do
      transition :finished => :rejected
    end

    event :guest_cancels_booking do
      transition [:unfinished, :finished,  :finished_host_accepted] => :guest_cancelled
    end

    event :reset_booking do
      transition :payment_authorisation_pending => :unfinished
    end

    event :try_payment do
      transition :unfinished => :payment_authorisation_pending
    end

    event :payment_check_succeed do
      transition [:unfinished, :payment_authorisation_pending] => :finished
    end

    event :payment_check_failed do
      transition :payment_authorisation_pending => :unfinished
    end

    event :host_requested_cancellation do
      transition :finished_host_accepted => :host_requested_cancellation
    end

    event :admin_cancel_booking do
      transition :host_requested_cancellation => :host_cancelled
    end

    event :host_accepts_booking  do
      transition :finished => :finished_host_accepted
    end
  end

  def self.valid_host_view_booking_states_list
    [:finished, :finished_host_accepted, :host_paid, :rejected, :host_requested_cancellation, :host_cancelled, :guest_cancelled]
  end

  def host_view?(user)
    self.owner_accepted? && (self.state?(:finished) || self.state?(:finished_host_accepted)) && user == self.bookee
  end

  def owner_view?(user)
    user == self.booker
  end

  def is_cancelled?
    (self.state?(:host_cancelled) or self.state?(:guest_cancelled))
  end

  def host_cancel?
    (self.can_admin_cancel_booking? and self.check_in_date >= Date.today)
  end

  def guest_cancel?
    (self.can_guest_cancels_booking? and self.check_in_date >= Date.today)
  end

  def editable_datetime?(user)
    self.enquiry.blank? && !self.host_view?(user) && !self.owner_accepted
  end

  def confirmed_by_host(current_user)
    if self.payment.present?
       result = Braintree::Transaction.submit_for_settlement(self.payment.braintree_transaction_id)
       # The follow line still causes error in production
       # raise Raygun.track_exception(custom_data: {time: Time.now, user: current_user.id, reason: "BrainTree transaction settlement failed", result: result, payment_id: self.payment.id})
    end
    message = nil
    if [6, 7].include?(self.response_id)
      self.host_accepted = false
    else
      self.response_id = 5
      self.host_accepts_booking #trigger host accepts booking event
      self.host_accepted = true
    end

    if self.response_id == 5
      results = self.complete_transaction(current_user)
      if results.class == String && Rails.env != "development"
        message = 'An error has occurred. Sorry for inconvenience. Please consult PetHomeStay Team'
        UserMailer.error_report('host confirming transaction', results).deliver
      else
        message = 'You have confirmed the booking'
        self.save!
        PetOwnerMailer.booking_confirmation(self).deliver
        ProviderMailer.booking_confirmation(self).deliver
        # self.mailbox.messages.create! user_id: booker_id,
        #   message_text: "[This is an auto-generated message for the Guest]\n\nGreat! This Host has confirmed your booking request!\nNow simply drop your pet off on the check-in date & don't forget to leave feedback once the stay has been completed! \nThanks for using PetHomestay!"
        # self.mailbox.messages.create! user_id: bookee_id,
        #   message_text: "[This is an auto-generated message for the Host]\n\nYou have confirmed the booking.\nThe Guest will drop their pet off on the check-in date & leave a feedback once the stay has been completed! \nThanks for using PetHomestay!"
        self.mailbox.update_attributes host_read: false, guest_read: false
      end

    elsif self.response_id == 6
      message = 'Guest will be informed of your unavailability'
      self.host_rejects_booking
      self.save!
      # self.mailbox.messages.create! user_id: booker_id,
      #   message_text: "[This is an auto-generated message for the Guest]\n\nUnfortunately this Host is unavailable for this Homestay.\nYour credit card has not been charged. Please choose another Host in your area.\nPlease ring us on 1300 660 945 if you need help."
      # self.mailbox.messages.create! user_id: bookee_id,
      #   message_text: "[This is an auto-generated message for the Host]\n\nYou have declined this booking."
      self.mailbox.update_attributes host_read: false, guest_read: false
      PetOwnerMailer.provider_not_available(self).deliver
    elsif self.response_id == 7
      message = 'Your question has been sent to guest'
      old_message = self.response_message
      self.response_message = nil
      self.save!
      PetOwnerMailer.provider_has_question(self, old_message).deliver
    end
    if self.response_message.present?
      self.mailbox.messages.create! user_id: bookee_id, message_text: self.response_message
    end
    message
  end

  def remove_notification
    self.response_id = 1
    self.save!
  end

  def update_transaction_by(number_of_nights=nil, check_in_date=nil, check_out_date=nil)
    if number_of_nights.blank? && check_in_date.blank? && check_out_date.blank?
      return { error: true }
    end
    self.check_in_date = check_in_date.try(:to_date) if check_in_date.present?
    self.check_out_date = check_out_date.try(:to_date) if check_out_date.present?
    self.number_of_nights = (self.check_out_date - self.check_in_date).to_i > 0 ? (self.check_out_date - self.check_in_date).to_i : 1

    self.subtotal = self.number_of_nights * self.cost_per_night
    self.amount = self.calculate_amount
    self.save!

    # self.transaction.amount = self.amount
    # self.transaction.time_stamp = Time.now.gmtime.strftime("%Y%m%d%H%M%S")
    # fingerprint_string = "#{ENV['MERCHANT_ID']}|#{ENV['TRANSACTION_PASSWORD']}|#{self.transaction.type_code}|#{self.transaction.
    #     reference}|#{self.transaction.actual_amount}|#{self.transaction.time_stamp}"

    # self.transaction.merchant_fingerprint = Digest::SHA1.hexdigest(fingerprint_string)
    # self.transaction.save!

    {
        booking_subtotal: self.subtotal.to_s,
        booking_amount: self.amount.to_s #,
        # transaction_fee: self.transaction_fee,
        # transaction_actual_amount: self.transaction.actual_amount,
        # transaction_time_stamp: self.transaction.time_stamp,
        # transaction_merchant_fingerprint: self.transaction.merchant_fingerprint
    }
  end

  def update_transaction_by_daily_price(price)
    self.subtotal = self.number_of_nights * price.to_f
    self.amount   = self.calculate_amount
    self.save!
  end

  def complete_transaction(current_user)
    if self.host_accepted?
      if self.host_view?(current_user)
        return self.transaction.complete_payment if self.transaction.present?
      end
      if self.owner_view?(current_user)
        self.remove_notification
      end
    end
  end

  # Sends email to host saying that payment made, they just need to accept
  def trigger_host_accept
    ProviderMailer.owner_confirmed(self).deliver
    self.block_out_dates
    # self.host_accepts_booking
    # self.host_accepted = true
    # self.save!
  end

  def block_out_dates
    return unless self.check_out_date && self.check_in_date
    return unless self.check_out_date > self.check_in_date
    user = self.bookee
    start = self.check_in_date
    (start..check_out_date).each do |booking_date|
      next if booking_date == check_out_date
      user.unavailable_dates.create(:date => booking_date)
    end
  end

  def phs_service_charge
    actual_value_figure(transaction_mode_value(self.subtotal * 0.15))
  end

  def public_liability_insurance
    self.number_of_nights * PER_NIGHT_LIABILITY_INSURANCE_COST
  end

  def host_payout_deduction
    transaction_mode_value(public_liability_insurance.to_f + phs_service_charge.to_f)
  end

  def host_payout
    actual_value_figure(subtotal - host_payout_deduction)
  end

  def transaction_fee
    self.subtotal * CREDIT_CARD_SURCHARGE_IN_DECIMAL
  end

  def credit_card_fee
    self.subtotal * CREDIT_CARD_SURCHARGE_IN_DECIMAL
  end

  def fees
    actual_value_figure(credit_card_fee)
  end

  def actual_amount
    return '00.00' if self.amount.blank?
    actual_value_figure(amount)
  end

  def actual_value_figure(value)
    value = self.send(value) if value.class == Symbol
    fraction = value.to_s.split('.').last
    if fraction.size == 1
      "#{value.to_s}0"
    elsif fraction.size == 2
      value.to_s
    elsif fraction.size > 2
      value.round(2).to_s
    end
  end

  def calculate_amount
    return self.subtotal*CREDIT_CARD_SURCHARGE_IN_DECIMAL + self.subtotal
  end

  def transaction_mode_value(value)
    if live_mode_rounded_value?
      return value.round(2)
    else
      integer_part = value.to_s.split('.')[0]
      fraction_part = value.to_s.split('.')[1]
      fraction_part = fraction_part.to_i > 0 ? '.08' : '.00'
      (integer_part + fraction_part).to_f
    end
  end

  def live_mode_rounded_value?
    ENV['LIVE_MODE_ROUNDED_VALUE'] == 'true' ? true : false
  end

  def message_update(new_message)
    old_message = self.message
    self.message = new_message
    self.save!

    if old_message.blank?
      # self.mailbox.messages.create! user_id: self.booker_id,
      #   message_text: "[This is an auto-generated message for the Guest]\n\nThis is a record of your booking request. No further action is required.\n\nIf you are a Host, please confirm or edit by clicking the button below."
      # self.mailbox.messages.create! user_id: self.bookee_id,
      #   message_text: "[This is an auto-generated message for the Host]\n\nPlease confirm or edit this booking by clicking the button below."
      self.mailbox.update_attributes host_read: false, guest_read: false
      unless new_message.empty?
       self.mailbox.messages.create! message_text: new_message, user_id: self.booker_id
      end
    else
      message = Message.find_by_user_id_and_mailbox_id(self.booker_id, self.mailbox.id)
      message.message_text = new_message
      message.save!
    end
  end

  # Designed to eventually replace state_machine or update booking states
  def get_status
    return "Cancelled" if self.cancel_date.present?
    if self.owner_accepted
      # Booking 'booked' if both owner & host accepted, payment made, but stay not completed
      return "Booked" if self.host_accepted && self.payment.present? && self.check_out_date.to_time > Time.now
      # Booking 'completed' if both owner & host accepted, payment made and stay completed
      return "Completed" if self.host_accepted && self.payment.present? && self.check_out_date.to_time < Time.now && self.enquiry.feedbacks.present?
      # Booking 'Leave feedback' if completed, paid, but no feedback
      return "Leave Feedback" if self.host_accepted && self.payment.present? && self.check_out_date.to_time < Time.now && self.enquiry.feedbacks.empty?
      # Booking rejected
      return "Booking rejected" if self.host_accepted == false && self.owner_accepted
      # Booking 'Waiting on host' if owner accepted but not host accepted
      return "Pending action - #{self.bookee.first_name}" if self.host_accepted != true && self.payment.present?
    elsif self.host_accepted && self.owner_accepted != true
      return "Pending action - #{self.booker.first_name}"
    else
      return "Enquiry"
    end
  end

  def get_status_css
    return "enquiry" if self.owner_accepted.nil? || self.host_accepted.nil?
    return "requested" if (self.owner_accepted || self.host_accepted) && self.payment.nil?
    return "cancelled" if (self.host_accepted == false && self.payment.present?) || self.cancel_date.present?
    return "booked" if self.payment.present? && self.host_accepted
  end

  def host_booking_status
    pending_or_rejected = (self.state?(:rejected)) ? 'Rejected' : 'Pending'
    "Booking $#{self.host_payout} - #{self.host_accepted? ? 'Accepted' : pending_or_rejected}"
  end

  def guest_booking_status
    pending_or_rejected = (self.state?(:rejected)) ? 'Rejected' : 'Pending'
    "Booking $#{self.actual_amount} - #{self.host_accepted? ? 'Accepted' : pending_or_rejected}"
  end

  private

  #TODO add this validation later
  #
  #def is_host_available_btw_check_in_and_check_out_date
    #booked_dates = self.bookee.booked_dates_between(self.check_in_date, self.check_out_date)
    #unavailable_dates = self.bookee.unavailable_dates.between(self.check_in_date, self.check_out_date).map(&:date)
    #if booked_dates.present? || unavailable_dates.present?
      #unavailable_dates = (unavailable_dates + booked_dates).uniq
      #errors.add(:host, "is either unavailable or booked on #{unavailable_dates.join(", ")}")
    #end
  #end

  def check_out_date_is_not_less_than_check_in_date
    errors.add(:check_in_date, "should be less than or equal to check out date") if check_out_date < check_in_date
  end

end
