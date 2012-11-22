class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, \
                  :first_name, :last_name, :date_of_birth, :validate_first_step_only, \
                  :mobile_number, :phone_number, :address_1, :address_2, :address_suburb, \
                  :address_city, :address_country, :address_postcode, :completed_signup, \
                  :current_password, :accept_house_rules, :accept_terms

  attr_accessor   :current_password, :accept_house_rules, :accept_terms

  has_one :homestay
  has_many :ratings
  has_many :pets
  has_many :enquiries

  has_many :given_feedbacks, class_name: 'Feedback'
  has_many :received_feedbacks, class_name: 'Feedback', foreign_key: 'subject_id'

  validates_presence_of :first_name, :last_name, :date_of_birth, :address_1, :address_suburb, \
                        :address_city, :address_country

  validates_acceptance_of :accept_house_rules, on: :create
  validates_acceptance_of :accept_terms, on: :create

  def name
    "#{first_name} #{last_name}"
  end

  def pet_names
    pets.map(&:name).to_sentence
  end

  def notifications?
    unanswered_enquiries? || enquiries_needing_confirmation? || owners_needing_feedback? || homestays_needing_feedback?
  end

  def unanswered_enquiries?
    unanswered_enquiries.present?
  end

  def unanswered_enquiries
    if homestay.present?
      homestay.enquiries.unanswered
    end
  end

  def enquiries_needing_confirmation?
    enquiries_needing_confirmation.present?
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

  def homestay_id
    homestay.present? ? homestay.id : nil
  end

  def pets_by_type
    pets.inject({}) do |hash, pet|
      hash[pet.pet_type] ||= []
      hash[pet.pet_type] << pet
      hash
    end
  end

  def pet_name
    if pets.length == 1
      pets.first.name
    else
      "your pets"
    end
  end

  def pet_count_by_type
    pets_by_type.inject({}) do |hash, (k,v)|
      hash[k] = v.length
      hash
    end
  end

  def pet_count_summary
    pet_count_by_type.map do |k,v|
      "#{v} #{k.pluralize(v)}"
    end.join(', ')
  end

  def pet_summary
    "#{pets.length} #{'pet'.pluralize(pets.length)} (#{pet_count_summary})"
  end

  def average_rating
    if received_feedbacks.present?
      received_feedbacks.inject(0) do |sum, feedback|
        sum += feedback.rating
      end / received_feedbacks.count
    else
      0
    end
  end
end
