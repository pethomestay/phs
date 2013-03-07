class Pet < ActiveRecord::Base
  belongs_to :user
  has_many :pictures, as: 'picturable'
  has_and_belongs_to_many :enquiries

  accepts_nested_attributes_for :pictures, reject_if: :all_blank

  attr_accessible :breed, :name, :age, :pet_type_id, :size_id, :sex_id, :microchip_number,
                  :council_number, :dislike_people, :dislike_animals,
                  :dislike_children, :dislike_loneliness, :explain_dislikes,
                  :pictures, :pictures_attributes, :flea_treated, :vaccinated, :house_trained,
                  :other_pet_type, :emergency_contact_name, :emergency_contact_phone, :vet_name,
                  :vet_phone, :medication, :date_of_birth


  validates_presence_of :name, :date_of_birth, :emergency_contact_name, :emergency_contact_phone
  validates_inclusion_of :pet_type_id, :in => [1,2,3,4,5]
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

  def pet_type
    ReferenceData::PetType.find(pet_type_id) if pet_type_id
  end

  def sex
    ReferenceData::Sex.find(sex_id) if sex_id
  end

  def size
    ReferenceData::Size.find(size_id) if size_id
  end
end
