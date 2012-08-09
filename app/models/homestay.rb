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
  accepts_nested_attributes_for :pictures, reject_if: :all_blank
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
                  :pet_training, :pet_walking
  attr_accessor :unfinished_signup, :accept_house_rules, :accept_terms

  validates_presence_of :cost_per_night
  validates_presence_of :address_1, :address_suburb, :address_city, :address_country
  validates_presence_of :title, :description, :unless => :unfinished_signup

  validates_acceptance_of :is_homestay, accept: true, unless: Proc.new {|homestay| homestay.is_sitter || homestay.is_services}
  validates_acceptance_of :is_sitter, accept: true, unless: Proc.new {|homestay| homestay.is_homestay || homestay.is_services}
  validates_acceptance_of :is_services, accept: true, unless: Proc.new {|homestay| homestay.is_homestay || homestay.is_sitter}

  validates_acceptance_of :accept_house_rules, on: :create, if: Proc.new {|homestay| homestay.is_homestay || homestay.is_sitter}

  validates_inclusion_of :property_type, :in => PROPERTY_TYPE_OPTIONS.map(&:first), if: :is_homestay?
  validates_inclusion_of :outdoor_area, :in => OUTDOOR_AREA_OPTIONS.map(&:first), if: :is_homestay?
  
  scope :active, where(active: true)

  geocoded_by :geocoding_address
  after_validation :geocode, unless: Proc.new {|hotel| hotel.latitude && hotel.longitude}

  def geocoding_address
    "#{address_1}, #{address_city}, #{address_country}"
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
end
