class Pet < ActiveRecord::Base
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

  validates_presence_of :name, :age
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
