class Pet < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :enquiries
  has_many :pictures, as: 'picturable'
  accepts_nested_attributes_for :pictures

  attr_accessible :breed, :name, :age, :pet_type, :size, :sex, :microchip_number, \
                  :council_number, :dislike_people, :dislike_animals, \
                  :dislike_children, :dislike_loneliness, :explain_dislikes, \
                  :pictures, :pictures_attributes, :flea_treated, :vaccinated, :house_trained, \
                  :other_pet_type
  attr_accessor :sex, :age, :microchip_number, :council_number, :size, :explain_dislikes, :other_pet_type

  validates_presence_of :name, :age
  validates_inclusion_of :pet_type, :in => %w( dog cat bird fish other )
  validates_inclusion_of :size, :in => %w( small medium large giant )
  validates_inclusion_of :sex, :in => %w( male_desexed female_desexed male_entire female_entire )
  
  validates_presence_of :other_pet_type, if: proc {|pet| pet.pet_type == 'other'}
end
