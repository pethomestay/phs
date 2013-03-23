class Homestay < ActiveRecord::Base
  include ActionView::Helpers

  belongs_to :user
  has_many :enquiries
  has_many :pictures, as: 'picturable'
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

  attr_accessor :parental_consent, :accept_liability

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

  before_validation :titleize_attributes

  before_create :create_slug
  before_save :sanitize_description

  def to_param
    self.slug
  end

  def create_slug
    self.slug = self.title.parameterize
  end

  def sanitize_description
    self.description = strip_tags(self.description) if self.description.present?
  end

  def titleize_attributes
    %w{title address_suburb address_city}.each do |attribute|
      send "#{attribute}=", send(attribute).titleize
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
    user.date_of_birth > 18.years.ago.to_date
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
    "#{address_suburb}, #{address_city}"
  end

  def average_rating
    user.average_rating
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
