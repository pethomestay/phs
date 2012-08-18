class Homestay < ActiveRecord::Base
  PROPERTY_TYPE_OPTIONS = {
    'house'     => 'House',
    'apartment' => 'Apartment',
    'farm'      => 'Farm',
    'townhouse' => 'Townhouse',
    'unit'      => 'Unit'
  }

  OUTDOOR_AREA_OPTIONS = {
    'small'     => 'Small (up to 10sq m)',
    'medium'    => 'Medium (up to 50sq m)',
    'large'     => 'Large (50sq m+)'
  }

  has_many :enquiries
  has_many :ratings, as: 'ratable'
  has_many :pictures, as: 'picturable'
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true
  belongs_to :user

  attr_accessible :title, :description, :cost_per_night, :active, \
                  :address_1, :address_2, :address_suburb, :address_city, \
                  :address_postcode, :address_country, :latitude, :longitude, \
                  :is_homestay, :is_sitter, :is_services, :years_looking_after_pets, \
                  :constant_supervision, :emergency_transport, :first_aid, \
                  :insurance, :professional_qualification, :pictures_attributes, \
                  :website, :accept_house_rules, :accept_terms, :sitter_cost_per_night, \
                  :pets_present, :outdoor_area, :property_type, :supervision_outside_work_hours, \
                  :fenced, :children_present, :police_check, :pet_feeding, :pet_grooming, \
                  :pet_training, :pet_walking, :is_professional

  validates_presence_of :cost_per_night
  validates_presence_of :address_1, :address_suburb, :address_city, :address_country
  validates_presence_of :title, :description

  validates_acceptance_of :is_homestay, accept: true, unless: Proc.new {|homestay| homestay.is_sitter || homestay.is_services}
  validates_acceptance_of :is_sitter, accept: true, unless: Proc.new {|homestay| homestay.is_homestay || homestay.is_services}
  validates_acceptance_of :is_services, accept: true, unless: Proc.new {|homestay| homestay.is_homestay || homestay.is_sitter}

  validates_inclusion_of :property_type, :in => PROPERTY_TYPE_OPTIONS.map(&:first), if: :is_homestay?
  validates_inclusion_of :outdoor_area, :in => OUTDOOR_AREA_OPTIONS.map(&:first), if: :is_homestay?

  scope :active, where(active: true)

  geocoded_by :geocoding_address
  after_validation :geocode, unless: Proc.new {|hotel| hotel.latitude && hotel.longitude}

  def geocoding_address
    "#{address_1}, #{address_city}, #{address_country}"
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

  def pretty_property_type
    PROPERTY_TYPE_OPTIONS[property_type]
  end

  def pretty_outdoor_area
    OUTDOOR_AREA_OPTIONS[outdoor_area]
  end

  def location
    "#{address_suburb}, #{address_city}"
  end

  def average_rating
    if ratings.present?
      ratings.inject(0) do |sum, rating|
        sum += rating.stars
      end / ratings.count
    else
      0
    end
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
end
