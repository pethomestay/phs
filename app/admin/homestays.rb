ActiveAdmin.register Homestay do
  controller do
    defaults :finder => :find_by_slug
  end

  index do
    column :title
    column 'Suburb', :address_suburb
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :user
      f.input :title
      f.input :slug
      f.input :cost_per_night
      f.input :is_professional
      f.input :description
      f.input :address_1
      f.input :address_2
      f.input :address_suburb
      f.input :address_postcode
      f.input :address_country, as: 'string'
      f.input :constant_supervision
      f.input :emergency_transport
      f.input :first_aid
      f.input :insurance
      f.input :professional_qualification
      f.input :website
      f.input :property_type, as: :select, collection: Homestay::PROPERTY_TYPE_OPTIONS.invert
      f.input :outdoor_area, as: :select, collection: Homestay::OUTDOOR_AREA_OPTIONS.invert
      f.input :supervision_outside_work_hours
      f.input :fenced
      f.input :children_present
      f.input :pets_present
      f.input :police_check
      f.input :pet_feeding
      f.input :pet_grooming
      f.input :pet_training
      f.input :pet_walking
    end
    f.buttons
  end

  actions :all, :except => [:new, :create]
  config.batch_actions = false

  show do
    panel "PetHomeStay Details" do
      attributes_table_for homestay do
        row 'Provider' do
          homestay.user
        end
        row :title
        row :slug
        row 'Cost per night' do
          number_to_currency homestay.cost_per_night
        end
        row :created_at
        row :is_professional
        row :description
        row 'Address' do
          [
            homestay.address_1,
            homestay.address_2,
            homestay.address_suburb,
            homestay.address_city,
            homestay.address_postcode,
            homestay.address_country
          ].delete_if(&:blank?).join("<br />").html_safe
        end
        row 'Latitude / Longitude' do
          "#{homestay.latitude} / #{homestay.longitude}"
        end
        row :constant_supervision
        row :emergency_transport
        row :first_aid
        row :insurance
        row :professional_qualification
        row :website
        row 'Property type' do
          homestay.pretty_property_type
        end
        row 'Outdoor area' do
          homestay.pretty_outdoor_area
        end
        row :supervision_outside_work_hours
        row :fenced
        row :children_present
        row :pets_present
        row :police_check
        row 'Services offered' do
          homestay.pretty_services
        end
      end
    end
  end
end
