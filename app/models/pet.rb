class Pet < ActiveRecord::Base
  belongs_to :user
  has_attachment  :profile_photo, accept: [:jpg, :png, :bmp, :gif]
  has_attachments :extra_photos, maximum: 10
  has_many :pictures, as: 'picturable', :class_name => "UserPicture"
  has_and_belongs_to_many :enquiries

  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :name, :pet_type_id, :size_id, :pet_age, :sex_id, :energy_level
  validates_presence_of :other_pet_type, if: proc {|pet| pet.pet_type_id == 5} # when pet type is 'other'
  validates_inclusion_of :pet_type_id, :in => ReferenceData::PetType.all.map(&:id)
  validates :energy_level, inclusion: { in: 1..5 } # Low, low medium, medium, high medium, and high
  validates_inclusion_of :size_id, :in => ReferenceData::Size.all.map(&:id), if: Proc.new {|pet| pet.pet_type_id == 1}
  validates_inclusion_of :sex_id, :in => ReferenceData::Sex.all.map(&:id), if: Proc.new {|pet| [1,2].include?(pet.pet_type_id)}
  validates :pet_age, inclusion: { in: 1..15 }

  serialize :personalities, Array

  attr_accessible :name, :pet_type_id, :other_pet_type, :breed, :size_id,
    :pet_age, :sex_id, :energy_level, :personalities, :emergency_contact_name,
    :emergency_contact_phone, :vet_name, :vet_phone, :council_number,
    :microchip_number, :medication, :house_trained, :flea_treated, :vaccinated,
    :dislike_children, :dislike_animals, :dislike_loneliness, :dislike_people

  before_validation :strip_personalities
  before_save :null_pet_to_empty_string, on: :create
  
  def pet_age
    if self.date_of_birth.present?
      diff = Date.today.year - self.date_of_birth.year
      case diff
      when 0..1 # Under 18 months
        1
      when 2..14 # 2 to 14 years old
        diff
      else # 15+
        15
      end
    else
      5
    end
  end

  def pet_age=(age)
    self.date_of_birth = Date.parse "#{age.to_i.years.ago.year}-01-01"
  end

  def dislikes
    dislikes = []
    dislikes << 'Dislikes children' if dislike_children
    dislikes << 'Dislikes being left alone' if dislike_loneliness
    dislikes << 'Dislikes strangers' if dislike_people
    dislikes << 'Dislikes other animals' if dislike_animals

    dislikes.join(', ')
  end

  def age
    now = Time.now.utc.to_date
    years = now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)

    if years > 0
      "#{years} #{'years'.pluralize(years)} old"
    else
      "Less than 1 year old"
    end
  end

  def pet_type
    ReferenceData::PetType.find(pet_type_id) if pet_type_id
  end

  def pet_type_name
    pet_type.title if pet_type_id
  end

  def sex
    ReferenceData::Sex.find(sex_id) if sex_id
  end

  def sex_name
    sex.title if sex_id
  end

  def size
    ReferenceData::Size.find(size_id) if size_id
  end

  def size_name
    size.title if size_id
  end

  private

  def strip_personalities
    self.personalities.delete('') if self.personalities.present?
  end
  
  # Set the pet breed to nil if users select animals like cats or other.
  # Need to improve this hotfix. This solves the problem of users entering cats
  # and sms's being sent out for cats and other animals. 
  # Sets breed to empty string instead of null. 
  def null_pet_to_empty_string
    self.breed = '' if breed.nil?
  end

end
