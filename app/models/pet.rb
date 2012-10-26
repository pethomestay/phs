class Pet < ActiveRecord::Base
  PET_TYPE_OPTIONS = {
    'dog'   => 'Dog',
    'cat'   => 'Cat',
    'bird'  => 'Bird',
    'fish'  => 'Fish',
    'other' => 'Other'
  }

  SIZE_OPTIONS = {
    'small'   => 'Small (0-15kg)',
    'medium'   => 'Medium (16-30kg)',
    'large'  => 'Large (31-45kg)',
    'giant'  => 'Giant (46kg+)'
  }

  SEX_OPTIONS = {
    'male_desexed'   => 'Male desexed',
    'female_desexed'   => 'Female desexed',
    'male_entire'  => 'Male entire',
    'female_entire'  => 'Female entire'
  }

  belongs_to :user
  has_and_belongs_to_many :enquiries
  has_many :pictures, as: 'picturable'
  accepts_nested_attributes_for :pictures, reject_if: :all_blank

  attr_accessible :breed, :name, :age, :pet_type, :size, :sex, :microchip_number, \
                  :council_number, :dislike_people, :dislike_animals, \
                  :dislike_children, :dislike_loneliness, :explain_dislikes, \
                  :pictures, :pictures_attributes, :flea_treated, :vaccinated, :house_trained, \
                  :other_pet_type, :emergency_contact_name, :emergency_contact_phone, :vet_name, \
                  :vet_phone, :medication

  validates_presence_of :name, :date_of_birth, :emergency_contact_name, :emergency_contact_phone
  validates_inclusion_of :pet_type, :in => %w( dog cat bird fish other )
  validates_inclusion_of :size, :in => %w( small medium large giant ), if: Proc.new {|pet| pet.pet_type == 'dog'}
  validates_inclusion_of :sex, :in => %w( male_desexed female_desexed male_entire female_entire ), if: Proc.new {|pet| ['cat', 'dog'].include?(pet.pet_type)}
  
  validates_presence_of :other_pet_type, if: proc {|pet| pet.pet_type == 'other'}

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

  def pretty_pet_type
    if pet_type == 'other'
      other_pet_type.capitalize
    else
      pet_type.capitalize
    end
  end

  def pretty_sex
    case sex
      when 'male_desexed' then 'Male desexed'
      when 'female_desexed' then 'Female desexed'
      when 'male_entire' then 'Male entire'
      when 'female_entire' then 'Female entire'
    end
  end

  def pretty_size
    size.capitalize
  end
end
