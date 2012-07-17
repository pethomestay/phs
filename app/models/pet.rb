class Pet < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :enquiries
  attr_accessible :breed, :name, :age, :type, :size, :sex, :microchip_number, \
                  :council_number, :dislike_people, :dislike_animals, \
                  :dislike_children, :dislike_loneliness, :explain_dislikes
  attr_accessor :sex, :age, :microchip_number, :council_number, :size, :explain_dislikes
  attr_accessor :dislike_loneliness, :dislike_children, :dislike_animals, :dislike_people

  validates_presence_of :name, :age
  validates_inclusion_of :type, :in => %w( dog cat bird fish other )
  # validates_presence_of :microchip_number, if: proc {|pet| pet.type == 'dog'}
end
