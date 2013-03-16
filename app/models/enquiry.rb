class Enquiry < ActiveRecord::Base
  belongs_to :user
  belongs_to :homestay
  has_many :feedbacks
  has_and_belongs_to_many :pets

  attr_accessible :pets, :user, :user_id, :homestay_id, :formatted_date, :date, :duration_id, :message, :response_id,
                  :confirmed, :owner_accepted, :response_message

  scope :unanswered, where(response_id: ReferenceData::Response::NONE.id)
  scope :unsent_feedback_email, where(sent_feedback_email: false)
  scope :need_confirmation, where(response_id: ReferenceData::Response::ACCEPTED.id, confirmed:false)
  scope :owner_accepted, where(owner_accepted: true)
  scope :need_feedback, lambda { where("owner_accepted IS NOT FALSE AND (date < ? AND (duration_id = 1 OR duration_id = 2 OR duration_id = 3 OR duration_id = 4)) OR \
                                        (date < ? AND (duration_id = 5)) OR \
                                        (date < ? AND (duration_id = 6)) OR \
                                        (date < ? AND (duration_id = 7)) OR \
                                        (date < ? AND (duration_id = 8)) OR \
                                        (date < ? AND (duration_id = 9)) OR \
                                        (date < ? AND (duration_id = 11))", 2.days.ago, 3.days.ago, 4.days.ago, 5.days.ago, 6.days.ago, 7.days.ago, 8.days.ago ) }

  validates_presence_of :response_message, if: :require_respsonse_message
  validates_inclusion_of :duration_id, :in => (1..ReferenceData::Duration.all.length)

  after_create :send_new_enquiry_notifications
  after_update :send_enquiry_update_notifications

  def duration
    ReferenceData::Duration.find_by_id(duration_id) if duration_id
  end

  def duration_name
    duration.title if duration_id
  end

  def response
    ReferenceData::Response.find(response_id) if response_id
  end

  def response_name
    response.title id response_id
  end

  def feedback_for_owner
    feedbacks.where('subject_id = ?', user.id).first
  end

  def feedback_for_homestay
    feedbacks.where('subject_id = ?', homestay.user.id).first
  end

  private
  def send_new_enquiry_notifications
    ProviderMailer.enquiry(self).deliver
  end

  def send_enquiry_update_notifications
    return unless response_id_changed?
    case response_id
      when ReferenceData::Response::ACCEPTED.id
        PetOwnerMailer.contact_details(self).deliver
      when ReferenceData::Response::UNDECIDED.id
        PetOwnerMailer.provider_undecided(self).deliver
      when ReferenceData::Response::DECLINED.id
        PetOwnerMailer.provider_unavailable(self).deliver
    end
  end

  def require_respsonse_message
    response_id == ReferenceData::Response::UNDECIDED.id
  end
end
