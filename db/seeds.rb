if Rails.env.development? || Rails.env.staging?
  User.destroy_all
  Homestay.destroy_all

  User.create({
    email:                  "test@example.com",
    password:               "test2010",
    password_confirmation:  "test2010",
    first_name:             "Testing",
    last_name:              "Guy"
  })
  4.times do
    user = User.create({
      email:                  "#{SecureRandom.hex}@pethomestay.com",
      password:               "test2010",
      password_confirmation:  "test2010"
    })
    user.build_homestay({
      title:            "Awesome PetHomeStay",
      address_1:        "94 Dixon Street",
      address_suburb:   "Te Aro",
      address_city:     "Wellington",
      address_country:  "New Zealand",
      cost_per_night:   15,
      active:           true,
      description:      <<-eos
        Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Nulla vitae elit libero, a pharetra augue. Cras mattis
        consectetur purus sit amet fermentum. Cum sociis natoque penatibus et
        magnis dis parturient montes, nascetur ridiculus mus.
      eos
    }).save
  end
end
