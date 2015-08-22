class Homestay < ActiveRecord::Base
  include ActionView::Helpers
  include HomestaysHelper

  MINIMUM_HOMESTAY_PRICE = 10

  belongs_to :user
  has_many :enquiries
  has_many :bookings
  has_many :pictures, as: 'picturable', :class_name => "UserPicture"
  has_attachments :photos, maximum: 10
  has_many :favourites
  has_many :users, through: :favourites, dependent: :destroy
  has_many :unavailable_dates, through: :user
  accepts_nested_attributes_for :pictures, reject_if: :all_blank,
    allow_destroy: true

  attr_accessor :parental_consent, :accept_liability, :position, :distance
  attr_accessible :title, :description, :cost_per_night, :property_type_id,
                  :outdoor_area_id, :is_professional, :insurance, :first_aid,
                  :professional_qualification, :constant_supervision,
                  :supervision_outside_work_hours, :emergency_transport,
                  :fenced, :children_present, :police_check, :website,
                  :address_1, :address_suburb, :address_city, :address_country,
                  :address_postcode, :pet_feeding, :pet_grooming, :pet_training,
                  :pet_walking, :accept_liability, :parental_consent,
                  :accept_liability, :active, :for_charity, :wildfire_badge, :pet_sizes,
                  :favorite_breeds, :emergency_sits, :pet_walking_price,
                  :pet_grooming_price, :remote_price, :visits_price,
                  :delivery_price, :visits_radius, :delivery_radius,
                  :energy_level_ids, :supervision_id, :auto_decline_sms, :auto_interest_sms

  serialize :pet_sizes,        Array
  serialize :favorite_breeds,  Array
  serialize :energy_level_ids, Array

  validates_presence_of :address_city,
    :address_country, :title, :description

  validates_acceptance_of :accept_liability, on: :create
  validates_acceptance_of :parental_consent, if: :need_parental_consent?

  validates :supervision_id, numericality: {
    in: ReferenceData::Supervision.all.map(&:id)
    }, if: 'supervision_id.present?'
  validates_uniqueness_of :slug

  validates_length_of :title, maximum: 50
  validates :cost_per_night,
  numericality: { greater_than_or_equal_to: MINIMUM_HOMESTAY_PRICE
  }, if: 'cost_per_night.present?'
  validates :remote_price, numericality: {
    greater_than_or_equal_to: 0
  }, if: 'remote_price.present?'
  validates :pet_walking_price, numericality: {
    greater_than_or_equal_to: 0
  }, if: 'pet_walking_price.present?'
  validates :pet_grooming_price, numericality: {
    greater_than_or_equal_to: 0
  }, if: 'pet_grooming_price.present?'
  validates :visits_price, presence: true, numericality: {
    greater_than_or_equal_to: 0
  }, if: 'visits_radius.present?'
  validates :visits_radius, presence: true, numericality: {
    greater_than_or_equal_to: 0, only_integer: true
  }, if: 'visits_price.present?'
  validates :delivery_price, presence: true, numericality: {
    greater_than_or_equal_to: 0
  }, if: 'delivery_radius.present?'
  validates :delivery_radius, presence: true, numericality: {
    greater_than_or_equal_to: 0, only_integer: true
  }, if: 'delivery_price.present?'
  validate :host_must_have_a_mobile_number

  scope :active, where(active: true)
  # scope :available_for_enquiry, ->(start_date, end_date) {Homestay.active.joins(:unavailable_dates).where("unavailable_dates.date NOT BETWEEN ? and ?", start_date.to_date, end_date.to_date)}
  scope :last_five, order('created_at DESC').limit(5)

  geocoded_by :geocoding_address
  after_validation :geocode

  before_validation :create_slug
  after_validation :copy_slug_errors_to_title

  before_save :sanitize_description
  before_save :strip_pet_sizes
  before_save :strip_favorite_breeds
  before_save :strip_energy_level_ids
  after_create :notify_intercom, if: 'Rails.env.production?'
  after_initialize :set_country_Australia # set country as Australia no matter what

  def notify_intercom
    Intercom::Event.create(:event_name => "homestay-created", :email => self.user.email, :created_at => self.created_at.to_i, :metadata => {
      :suburb          => self.address_suburb,
      :postcode        => self.address_postcode,
      :has_pictures    => self.pictures.present?,
      :has_cover_photo => self.photos.present?,
      :price_per_night => self.cost_per_night,
      :title_is_unique => Homestay.where(:title => self.title).count == 1
      })
  end

  def self.reject_unavailable_homestays(start_date = nil, end_date = nil)
    if start_date && end_date
      Homestay.active.reject {|h| ((start_date.to_date..end_date.to_date).to_a - h.unavailable_dates.collect(&:date)).any? }
    else
      Homestay.active
    end
  end

  def auto_interest_sms_text
    self.auto_interest_sms || "Hi, I would love to help look after your pet. Let's arrange a time to meet. My contact is #{self.user.mobile_number.present? ? self.user.mobile_number : self.user.email}"
  end

  def auto_decline_sms_text
    self.auto_decline_sms || "Sorry - I can't help this time, but please ask again in the future!"
  end

  def to_param
    self.slug
  end

  def create_slug
    self.slug = title.parameterize if title
  end

  def geocoding_address
    if address_suburb.nil?
      "#{address_1}, #{address_city}, #{address_country}"
    elsif address_1.nil?
      "#{address_suburb}, #{address_city}, #{address_country}"
    elsif address_suburb.present? && address_1.present?
      "#{address_1}, #{address_suburb}, #{address_city}, #{address_country}"
    elsif address_suburb.nil? && address_1.nil?
      "#{address_city}, #{address_country}"
    end
  end

  def need_parental_consent?
    user && user.date_of_birth.present? && user.date_of_birth > 18.years.ago.to_date
  end

  def emergency_preparedness?
    first_aid || emergency_transport
  end

  def supervision
    ReferenceData::Supervision.find(supervision_id) if supervision_id.present?
  end

  # Depreciated
  def supervision?
    supervision_outside_work_hours || constant_supervision
  end

  # Depreciated but may be used in other parts of the program, especially emails
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

  def energy_levels
    levels = []
    energy_level_ids.each do |id|
      levels << ReferenceData::EnergyLevel.find(id)
    end
    levels
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

  def host_must_have_a_mobile_number
    unless self.user.mobile_number.present?
      errors[:base] << 'A mobile number is needed so the Guest can contact you!'
    end
  end

  def copy_slug_errors_to_title
    errors.add(:title, errors.get(:slug)[0]) if errors.get(:slug)
  end

  def sanitize_description
    if self.description.present?
      self.description = strip_tags(self.description)
      self.description = strip_nbsp(self.description)
    end
  end

  def strip_pet_sizes
    self.pet_sizes.delete('') if self.pet_sizes.present?
  end

  def strip_favorite_breeds
    self.favorite_breeds.delete('') if self.favorite_breeds.present?
  end

  def strip_energy_level_ids
    self.energy_level_ids.delete('') if self.energy_level_ids.present?
  end

  def set_country_Australia
    self.address_country = 'Australia'
  end
end
