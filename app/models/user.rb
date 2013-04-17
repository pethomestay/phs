class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessor   :current_password, :accept_house_rules, :accept_terms

  has_one :homestay
  has_many :pets
  has_many :enquiries

  has_many :given_feedbacks, class_name: 'Feedback'
  has_many :received_feedbacks, class_name: 'Feedback', foreign_key: 'subject_id'

  validates_presence_of :first_name, :last_name, :date_of_birth, :address_1, :address_suburb,
                        :address_city, :address_country

  validates_acceptance_of :accept_house_rules, on: :create
  validates_acceptance_of :accept_terms, on: :create

  scope :last_five, order('created_at DESC').limit(5)

  def name
    "#{first_name} #{last_name}"
  end

  def notifications?
    unanswered_enquiries? || enquiries_needing_confirmation? || owners_needing_feedback? || homestays_needing_feedback?
  end

  def unanswered_enquiries?
    unanswered_enquiries.any?
  end

  def unanswered_enquiries
    homestay.present? ? homestay.enquiries.unanswered : []
  end

  def enquiries_needing_confirmation?
    enquiries_needing_confirmation.any?
  end

  def enquiries_needing_confirmation
    enquiries.need_confirmation
  end

  def owners_needing_feedback?
    owners_needing_feedback.present?
  end

  def owners_needing_feedback
    if homestay.present?
      homestay.enquiries.owner_accepted.need_feedback.delete_if {|e| e.feedback_for_owner.present? }
    end
  end

  def homestays_needing_feedback?
    homestays_needing_feedback.present?
  end

  def homestays_needing_feedback
    enquiries.owner_accepted.need_feedback.delete_if {|e| e.feedback_for_homestay.present? }
  end

  def pet_name
    if pets.length == 1
      pets.first.name
    else
      "your pets"
    end
  end

  def pet_names
    pets.map(&:name).to_sentence
  end

  def update_average_rating
    rating = received_feedbacks.count == 0 ? 0 : received_feedbacks.sum('rating') / received_feedbacks.count
    update_attribute :average_rating, rating
  end
end
