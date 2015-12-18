module HomestaysHelper
  def accepted_pet_size_description(homestay)
    sizes = homestay.pet_sizes
    unless sizes.empty?
      homestay.pet_sizes.last =~ /(\d+kg)\)$/
      biggest_size = $1
    end
    if sizes.empty?
      'Not specified'
    elsif sizes.size == ReferenceData::Size.all.size
      'All shapes and sizes!'
    elsif sizes.include?(ReferenceData::Size.all.first.title)
      "Up to #{biggest_size}"
    else
      homestay.pet_sizes.first =~ /(\d)\-/
      smallest_size = $1
      if sizes.include?(ReferenceData::Size.all.last.title)
        "From #{smallest_size}kg up"
      else
        "From #{smallest_size} to #{biggest_size}"
      end
    end
  end

  def pet_description(pet)
    breed = pet.breed.sub(/\s+\(.*\)/, '')
    breed = pet.pet_type.title.downcase if breed.blank?      
    "A #{pet.age.sub(' years old', '-year-old')} #{breed}"
  end

  def my_homestay?(homestay)
    current_user && homestay == current_user.homestay
  end

  def strip_nbsp(str)
    str.gsub(/&nbsp;/i," ")
  end

  def check_in_date
    params[:search][:check_in_date].present? ? params[:search][:check_in_date].to_date.strftime("%A, %d %B, %Y") : ""
  end

  def check_out_date
    params[:search][:check_out_date].present? ? params[:search][:check_out_date].to_date.strftime("%A, %d %B, %Y") : ""
  end

end
