if Rails.env.development? || Rails.env.staging?
  User.destroy_all
  User.create({
    email:                  "test@example.com",
    password:               "test2010",
    password_confirmation:  "test2010"
  })
  Sitter.destroy_all
  4.times do
    user = User.create({
      email:                  "#{SecureRandom.hex}@pethomestay.com",
      password:               "test2010",
      password_confirmation:  "test2010",
      address_1:              "94 Dixon Street",
      address_suburb:         "Te Aro",
      address_city:           "Wellington",
      address_country:        "New Zealand"
    })
    user.build_sitter({
      title:          "My First Homestay",
      cost_per_night: 15,
      distance: 20,
      active: true,
      description:    <<-eos
        Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Nulla vitae elit libero, a pharetra augue. Cras mattis
        consectetur purus sit amet fermentum. Cum sociis natoque penatibus et
        magnis dis parturient montes, nascetur ridiculus mus.
      eos
    }).save
  end
  Hotel.destroy_all
  5.times do
    Hotel.create({
      title:            "Awesome Pet Hotel",
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
    })
  end
end
