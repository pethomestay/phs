ActiveAdmin.register Feedback do
  actions :all, :except => [:new, :create]
  config.batch_actions = false

  index do
    column :created_at
    column :rating
    column 'From user' do |feedback|
      feedback.user.name
    end
    column 'About user' do |feedback|
      if feedback.enquiry.user == feedback.user
        feedback.enquiry.homestay.user.name
      else
        feedback.enquiry.user.name
      end
    end
    default_actions
  end

  filter :user, label: 'From user'
  filter :rating
  filter :created_at

  form do |f|
    f.inputs do
      f.input :rating
      f.input :review
    end
    f.buttons
  end

  show do
    panel "Feedback Details" do
      attributes_table_for feedback do
        row :created_at
        row 'From user' do
          feedback.user
        end
        row 'About user' do
          feedback.target_user
        end
        row 'Enquiry' do
          feedback.enquiry
        end
        row :rating
        row :review
      end
    end
  end
end
