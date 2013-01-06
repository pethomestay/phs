ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: 'PetHomeStay Dashboard' do

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Signups" do
          ul do
            User.find(:all, :order => "id desc", :limit => 5).map do |user|
              li link_to(user.name, admin_user_path(user))
            end
          end
        end

        panel "Recent PetHomeStays" do
          ul do
            Homestay.find(:all, :order => "id desc", :limit => 5).map do |homestay|
              li link_to(homestay.title, admin_homestay_path(homestay))
            end
          end
        end
      end

      column do
        panel "Quick stats" do
          table do
            ('<tr>' + [User, Homestay, Pet, Enquiry, Feedback, Picture].map do |model|
              "<td>#{model.table_name.capitalize}</td><td>#{model.count}</td>"
            end.join('</tr><tr>') + '</tr>').html_safe
          end
        end
      end
    end
  end # content
end
