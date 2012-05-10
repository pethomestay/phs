if Rails.env.development? || Rails.env.staging?
  Homestay.create({
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
