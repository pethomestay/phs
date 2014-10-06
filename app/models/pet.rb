class Pet < ActiveRecord::Base
  belongs_to :user
  has_many :pictures, as: 'picturable', :class_name => "UserPicture"
  has_and_belongs_to_many :enquiries

  accepts_nested_attributes_for :pictures, reject_if: :all_blank

  validates_presence_of :name, :date_of_birth
  validates_presence_of :other_pet_type, if: proc {|pet| pet.pet_type_id == 4}
  validates_inclusion_of :pet_type_id, :in => ReferenceData::PetType.all.map(&:id)
  validates_inclusion_of :size_id, :in => ReferenceData::Size.all.map(&:id), if: Proc.new {|pet| pet.pet_type_id == 1}
  validates_inclusion_of :sex_id, :in => ReferenceData::Sex.all.map(&:id), if: Proc.new {|pet| [1,2].include?(pet.pet_type_id)}

  serialize :personalities, Array

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

	def any_dislikes?
		self.dislike_loneliness? || self.dislike_children? || self.dislike_animals? || self.dislike_people?
	end
end
