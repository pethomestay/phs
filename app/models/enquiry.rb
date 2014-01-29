class Enquiry < ActiveRecord::Base
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

  after_create :create_mailbox
  after_create :send_new_enquiry_notifications

  before_save :set_response, on: :create
  after_update :send_enquiry_update_notifications

  scope :last_five, order('created_at DESC').limit(5)

  def create_mailbox
		mailbox_attributes = { enquiry_id: self.id, guest_mailbox_id: self.user_id, host_mailbox_id: self.homestay.user.id,
		                       guest_read: true }
	  self.mailbox.blank? ? Mailbox.create!(mailbox_attributes) : self.mailbox.update_attributes!(mailbox_attributes)
		self.reload
		self.mailbox.messages.create! message_text: self.message, user_id: self.user_id
  end

  def duration
    ReferenceData::Duration.find_by_id(duration_id) if duration_id
  end

  def duration_name
    duration.title if duration_id
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

  private
  def send_new_enquiry_notifications
    ProviderMailer.enquiry(self).deliver
  end

  def send_enquiry_update_notifications
    return if confirmed?
    PetOwnerMailer.host_enquiry_response(self).deliver
  end

  def require_respsonse_message
    response_id == ReferenceData::Response::UNDECIDED.id
  end

  def strip_phone_numbers(string)
    string.gsub /\d+[\s|\d]+/, ''
  end

  def set_response
    self.response_id = ReferenceData::Response::NONE.id unless response_id > 0
  end
end
