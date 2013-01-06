ActiveAdmin.register Pet do
  index do
    column :name
    column 'Pet Type', :pretty_pet_type
    column :breed
    default_actions
  end

  actions :all, :except => [:new, :create]
  config.batch_actions = false

  filter :name
  filter :pet_type, as: :select, collection: Pet::PET_TYPE_OPTIONS.invert
  filter :breed

  form do |f|
    f.inputs do
      f.input :user
      f.input :name
      f.input :pet_type, as: :select, collection: Pet::PET_TYPE_OPTIONS.invert
      f.input :other_pet_type
      f.input :sex, as: :select, collection: Pet::SEX_OPTIONS.invert
      f.input :size, as: :select, collection: Pet::SIZE_OPTIONS.invert
      f.input :breed
      f.input :date_of_birth
      f.input :dislike_people
      f.input :dislike_animals
      f.input :dislike_children
      f.input :dislike_loneliness
      f.input :explain_dislikes
      f.input :flea_treated
      f.input :vaccinated
      f.input :house_trained
      f.input :medication
      f.input :emergency_contact_name
      f.input :emergency_contact_phone
      f.input :vet_name
      f.input :vet_phone
    end
    f.buttons
  end

  show do
    panel "Pet Details" do
      attributes_table_for pet do
        row 'Owner' do
          pet.user
        end
        row :name
        row :age
        row 'Pet Type' do
          pet.pretty_pet_type
        end
        row 'Sex' do
          pet.pretty_sex
        end
        row 'Size' do
          pet.pretty_size
        end
        row :breed
        row :created_at
        row 'Dislikes' do
          pet.dislikes
        end
        row :microchip_number
        row :council_number
        row :flea_treated
        row :vaccinated
        row :house_trained
        row :medication
        row 'Emergency contact' do
          "#{pet.emergency_contact_name} : #{pet.emergency_contact_phone}"
        end
        row 'Vet' do
          "#{pet.vet_name} : #{pet.vet_phone}"
        end
      end
    end
  end
end
