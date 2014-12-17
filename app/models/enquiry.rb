class Enquiry < ActiveRecord::Base
  include ShortMessagesHelper

  MAX_ENQUIRIES_PER_DAY = 5

  belongs_to :user
  belongs_to :homestay
  has_many :feedbacks
  has_and_belongs_to_many :pets

  has_one :booking, dependent: :destroy
  has_one :mailbox, dependent: :destroy

  scope :unanswered, where(response_id: ReferenceData::Response::NONE.id)
  scope :unsent_feedback_email, where(sent_feedback_email: false)
  scope :need_confirmation, where("response_id IN (?) AND confirmed = false", [ReferenceData::Response::ACCEPTED.id,
    ReferenceData::Response::UNDECIDED.id, ReferenceData::Response::DECLINED.id])
  scope :owner_accepted, where(owner_accepted: true)
  scope :need_feedback, lambda { where("owner_accepted IS NOT FALSE AND (check_in_date < ? AND (duration_id = 1 OR duration_id = 2 OR duration_id = 3 OR duration_id = 4)) OR \
                                        (check_in_date < ? AND (duration_id = 5)) OR \
                                        (check_in_date < ? AND (duration_id = 6)) OR \
                                        (check_in_date < ? AND (duration_id = 7)) OR \
                                        (check_in_date < ? AND (duration_id = 8)) OR \
                                        (check_in_date < ? AND (duration_id = 9)) OR \
                                        (check_in_date < ? AND (duration_id = 11))", 2.days.ago, 3.days.ago, 4.days.ago, 5.days.ago, 6.days.ago, 7.days.ago, 8.days.ago ) }

  validates_presence_of :check_in_date, :check_out_date
  validates_presence_of :response_message, if: :require_respsonse_message
  validates_inclusion_of :duration_id, :in => (1..ReferenceData::Duration.all.length)
  validate :guest_must_have_a_mobile_number
  validate :day_limit
  validate :host_is_available

  after_create :create_mailbox
  after_create :send_new_enquiry_notifications
  after_create :send_new_enquiry_notification_SMS

  before_save :set_response, on: :create
  after_save :create_or_modify_booking

  scope :last_five, order('created_at DESC').limit(5)

  def create_mailbox
    mailbox_attributes = { enquiry_id: self.id, guest_mailbox_id: self.user_id, host_mailbox_id: self.homestay.user.id }
    self.mailbox.blank? ? Mailbox.create!(mailbox_attributes) : self.mailbox.update_attributes!(mailbox_attributes)
    self.reload
    self.mailbox.messages.create! message_text: self.message, user_id: self.user_id
  end

  def duration
    ReferenceData::Duration.find_by_id(duration_id) if duration_id
  end

  def stay_length
    (self.check_out_date - self.check_in_date) <= 1 ? 1 : (self.check_out_date - self.check_in_date).to_i
  end

  def duration_name
    duration.title if duration_id
  end

  def create_or_modify_booking
    self.user.find_or_create_booking_by(self, self.homestay)
  end

  def response
    ReferenceData::Response.find(response_id) if response_id && response_id > 0
  end

  def response_name
    response.title if response_id && response_id > 0
  end

  def feedback_for_owner
    feedbacks.where(subject_id: user.id).first
  end

  def feedback_for_owner?
    feedback_for_owner.present?
  end

  def feedback_for_homestay
    feedbacks.where(subject_id: homestay.user.id).first
  end

  def feedback_for_homestay?
    feedback_for_homestay.present?
  end

  def first_host_response
    return nil if self.mailbox.blank?
    self.mailbox.messages
      .where('user_id != ?', self.user.id)
      .limit(1)[0] # First host response in this enquiry
  end

  private

  def guest_must_have_a_mobile_number
    unless self.user.mobile_number.present?
      errors[:base] << 'A mobile number is needed so the Host can contact you!'
    end
  end

  def day_limit
    today_count = self.user.enquiries.select(:created_at)
                  .where('created_at > ?',
                         Time.now.in_time_zone('Melbourne').beginning_of_day)
                  .count
    if today_count > MAX_ENQUIRIES_PER_DAY
      errors[:base] << "Sorry! We only allow #{MAX_ENQUIRIES_PER_DAY} enquiries per day to minimise the risk of spam."
      if Rails.env.production?
        Intercom::Event.create(
          event_name: 'enquiry-limit-reached',
          created_at: Time.now.to_i,
          email: self.user.email,
        )
      end
    end
  end

  def host_is_available
    host = self.homestay.user
    unless host.is_available? from: self.check_in_date, to: self.check_out_date
      errors[:base] << "#{host.first_name} is not available during this period. Please refer to the calendar for availability info."
    end
  end

  def send_new_enquiry_notifications
    ProviderMailer.enquiry(self).deliver
  end

  def send_new_enquiry_notification_SMS
    send_sms to: self.homestay.user,
      text: "You have a new PetHomeStay Host Enquiry! Please reply within 24 hours. Log in via mobile & ring direct from your Inbox!"
  end

  def require_respsonse_message
    response_id == ReferenceData::Response::UNDECIDED.id
  end

  def set_response
    self.response_id = ReferenceData::Response::NONE.id unless response_id > 0
  end
end
