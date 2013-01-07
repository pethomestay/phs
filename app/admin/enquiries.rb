ActiveAdmin.register Enquiry do
  actions :all, :except => [:new, :create, :edit, :update]
  config.batch_actions = false

  index do
    column :created_at
    column 'Pet Owner', Proc.new {|enquiry| enquiry.user.name }
    column 'PetHomeStay', Proc.new {|enquiry| enquiry.homestay.title }
    default_actions
  end

  filter :user, label: 'Pet Owner'
  filter :homestay, label: 'PetHomeStay'
  filter :created_at

  show do
    panel "Enquiry Details" do
      attributes_table_for enquiry do
        row 'Pet Owner' do
          enquiry.user
        end
        row 'PetHomeStay' do
          enquiry.homestay
        end
        row 'Enquiry for date' do
          enquiry.date
        end
        row 'Duration' do
          "Stay for #{enquiry.natural_duration}"
        end
        row :message
        row 'Status' do
          if enquiry.responded?
            if enquiry.accepted?
              if enquiry.confirmed?
                if enquiry.owner_accepted?
                  'Pet owner confirmed enquiry with PetHomeStay'
                else
                  'Pet owner did not choose to use PetHomeStay'
                end
              else
                'Pet owner needs to confirm booking'
              end
            else
              'PetHomeStay was not available'
            end
          else
            'PetHomeStay needs to confirm availability'
          end
        end
      end
    end
  end
end
