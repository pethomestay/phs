class Homestay < ActiveRecord::Base
  include ActionView::Helpers
  include HomestaysHelper

  belongs_to :user
  has_many :enquiries
  has_many :bookings
  has_many :pictures, as: 'picturable', :class_name => "UserPicture"
  has_attachments :photos, maximum: 10
  has_many :favourites
  has_many :users, through: :favourites, dependent: :destroy
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

  attr_accessor :parental_consent, :accept_liability
  attr_accessible :title, :description, :cost_per_night, :property_type_id, :outdoor_area_id, :is_professional, :insurance, :first_aid, :professional_qualification, :constant_supervision, :supervision_outside_work_hours, :emergency_transport, :fenced, :children_present, :police_check, :website, :address_1, :address_suburb, :address_city, :address_country, :address_postcode, :pet_feeding, :pet_grooming, :pet_training, :pet_walking, :accept_liability, :parental_consent, :accept_liability, :active


  validates_presence_of :cost_per_night, :address_1, :address_suburb, :address_city, :address_country, :title, :description

  validates_acceptance_of :accept_liability, on: :create
  validates_acceptance_of :parental_consent, if: :need_parental_consent?

  validates_inclusion_of :property_type_id, :in => ReferenceData::PropertyType.all.map(&:id)
  validates_inclusion_of :outdoor_area_id, :in => ReferenceData::OutdoorArea.all.map(&:id)
  validates_uniqueness_of :slug

  validates_length_of :title, maximum: 50

  scope :active, where(active: true)
  scope :last_five, order('created_at DESC').limit(5)

  geocoded_by :geocoding_address
  after_validation :geocode

  before_validation :create_slug
  after_validation :copy_slug_errors_to_title

  before_save :sanitize_description
  after_initialize :set_country_Australia # set country as Australia no matter what

  def to_param
    self.slug
  end

  def create_slug
    self.slug = title.parameterize if title
  end

  def sanitize_description
    if self.description.present?
      self.description = strip_tags(self.description)
      self.description = strip_nbsp(self.description)
    end
  end

  def geocoding_address
    if address_suburb.present?
      "#{address_1}, #{address_suburb}, #{address_city}, #{address_country}"
    else
      "#{address_1}, #{address_city}, #{address_country}"
    end
  end

  def need_parental_consent?
    user && user.date_of_birth.present? and user.date_of_birth > 18.years.ago.to_date
  end

  def emergency_preparedness?
    first_aid || emergency_transport
  end

  def supervision?
    supervision_outside_work_hours || constant_supervision
  end

  def pretty_supervision
    if constant_supervision
      'I can provide 24/7 supervision for your pets'
    elsif supervision_outside_work_hours
      'I can provide supervision for your pets outside work hours (8am - 6pm)'
    end
  end

  def pretty_emergency_preparedness
    if first_aid && emergency_transport
      'I know pet first-aid and can provide emergency transport'
    elsif first_aid
      'I know pet first-aid'
    elsif emergency_transport
      'I can provide emergency transport'
    end
  end

  def self.homestay_ids_unavailable_between(start_date, end_date)
    self.joins("inner join unavailable_dates on unavailable_dates.user_id = homestays.user_id")
      .where("unavailable_dates.date between ? and ?", start_date, end_date)
      .group("homestays.id").map(&:id)
  end

  def self.available_between(start_date, end_date)
    unavailable_homestay_ids = self.homestay_ids_unavailable_between(start_date, end_date)
    return self.scoped if unavailable_homestay_ids.blank?
    self.where('homestays.id NOT IN (?)', unavailable_homestay_ids)
  end

  def self.homestay_ids_booked_between(start_date, end_date)
    booked_condition = "bookings.check_in_date between ? and ? or (bookings.check_in_date < ? and bookings.check_out_date > ?)"
    self.joins("inner join bookings on bookings.bookee_id = homestays.user_id")
      .where("state = ? and (#{booked_condition})", :finished_host_accepted, start_date, end_date, start_date, start_date)
      .group("homestays.id").map(&:id)
  end

  def self.not_booked_between(start_date, end_date)
    booked_homestay_ids = self.homestay_ids_booked_between(start_date, end_date)
    return self.scoped if booked_homestay_ids.blank?
    self.where("homestays.id not in (?)", booked_homestay_ids)
  end

  def property_type
    ReferenceData::PropertyType.find(property_type_id) if property_type_id
  end

  def property_type_name
    property_type.title if property_type_id
  end

  def outdoor_area
    ReferenceData::OutdoorArea.find(outdoor_area_id) if outdoor_area_id
  end

  def outdoor_area_name
    outdoor_area.title if outdoor_area_id
  end

  def location
    if self.address_suburb != self.address_city # Avoid "Melbourne, Melbourne"
      "#{address_suburb}, #{address_city}"
    else
      "#{address_suburb}"
    end
  end

  def average_rating
    user.average_rating || 0
  end

  def has_services?
    pet_feeding || pet_grooming || pet_training || pet_walking
  end

  def pretty_services
    services = []
    services << 'Pet feeding' if pet_feeding
    services << 'Pet grooming' if pet_grooming
    services << 'Pet training' if pet_training
    services << 'Pet walking' if pet_walking
    services.to_sentence.downcase.capitalize
  end

  def favourite?(current_user)
	  !Favourite.where(user_id: current_user, homestay_id: self).blank?
  end

  private
  def copy_slug_errors_to_title
    errors.add(:title, errors.get(:slug)[0]) if errors.get(:slug)
  end

  def set_country_Australia
    self.address_country = 'Australia'
  end
end
