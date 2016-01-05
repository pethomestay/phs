module HomestaysHelper
  def contact_host_data(homestay)
    if user_signed_in?
      if current_user.pets.present?
        {toggle: 'modal', target: '#request-modal'}
      else
        {toggle: 'modal', target: '#request-modal-add-pet'}
      end
    else
      {toggle: 'modal', target: '#sign-up-modal'}
    end
  end

  def host_has_badges?(homestay)
    homestay.emergency_transport? || homestay.first_aid? || homestay.professional_qualification? || homestay.police_check?
  end

  def twitter_url(homestay)
    url = 'https://twitter.com/share'
    url += "?text=Check out this awesome pet sitter in #{@homestay.address_suburb} for only #{number_to_currency(@homestay.cost_per_night)} per night!"
    url += '&via=PetHomeStay'
    url += '&hashtags=freecuddles'
    url
  end

  def homestay_banner_image(homestay)
    public_id = homestay.photos.empty? ? 'doglow_y44iyi' : homestay.photos.first.public_id
    cl_image_path(
      public_id,
      angle: :exif,
      crop: :fill,
      effect: 'blur:5000',
      height: 400,
      quality: 80,
      width: 1200
    )
  end

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
    breed = if pet.breed.blank?
      pet.pet_type.title.downcase
    else
      pet.breed.sub(/\s+\(.*\)/, '')
    end
    a_or_an = [8,11,18].include?(pet.pet_age) ? 'An' : 'A'
    "#{a_or_an} #{pet.age.sub(' years old', '-year-old')} #{breed}"
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
