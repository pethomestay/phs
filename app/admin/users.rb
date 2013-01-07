ActiveAdmin.register User do
  index do
    column :created_at
    column :email
    column :name
    column :address_suburb
    default_actions
  end

  filter :email
  filter :first_name
  filter :last_name

  actions :all, :except => [:new, :create]
  config.batch_actions = false

  form do |f|
    f.inputs do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :date_of_birth
      f.input :phone_number
      f.input :mobile_number
      f.input :address_1
      f.input :address_2
      f.input :address_suburb
      f.input :address_postcode
      f.input :address_country, as: 'string'
      f.input :active
    end
    f.buttons
  end

  show do
    panel "User Details" do
      attributes_table_for user do
        row 'PetHomeStay' do
          user.homestay
        end
        row :email
        row :name
        row :created_at
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :date_of_birth
        row :phone_number
        row :mobile_number
        row 'Address' do
          [
            user.address_1,
            user.address_2,
            user.address_suburb,
            user.address_city,
            user.address_postcode,
            user.address_country
          ].delete_if(&:blank?).join("<br />").html_safe
        end
        row :active
      end
    end
  end
end
