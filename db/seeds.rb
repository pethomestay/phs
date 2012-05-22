if Rails.env.development? || Rails.env.staging?
  Sitter.destroy_all
  4.times do
    Sitter.create({
      title:        "My First Homestay",
      location:     "Wellington",
      price:        15,
      description:  <<-eos
        Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Nulla vitae elit libero, a pharetra augue. Cras mattis
        consectetur purus sit amet fermentum. Cum sociis natoque penatibus et
        magnis dis parturient montes, nascetur ridiculus mus.
      eos
    })
  end
  Hotel.destroy_all
  4.times do
    Hotel.create({
      title:          "A Pet Hotel",
      address_1:      "94 Dixon Street",
      address_suburb: "Te Aro",
      address_city:   "Wellington",
      location:       "Wellington",
      price:          15,
      description:    <<-eos
        Maecenas faucibus mollis interdum. Lorem ipsum dolor sit amet, consectetur
        adipiscing elit. Nulla vitae elit libero, a pharetra augue. Cras mattis
        consectetur purus sit amet fermentum. Cum sociis natoque penatibus et
        magnis dis parturient montes, nascetur ridiculus mus.
      eos
    })
  end
  User.destroy_all
  User.create({
    email:                  "test@example.com",
    password:               "test2010",
    password_confirmation:  "test2010"
  })
end
