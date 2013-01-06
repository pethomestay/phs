ActiveAdmin.register Picture do
  index as: :grid, columns: 6 do |picture|
    link_to(image_tag(picture.file.thumb('200x200#').url), admin_picture_path(picture))
  end

  filter :created_at

  actions :all, :except => [:new, :create, :edit, :update]
  config.batch_actions = false

  show title: Proc.new {|picture| "Picture of #{picture.picturable_type.downcase}" } do
    panel "Picture Details" do
      attributes_table_for picture, :created_at do
        row("Subject") do
          if picture.picturable_type == 'Homestay'
            homestay = Homestay.find_by_id(picture.picturable_id)
            url = admin_homestay_path(homestay)
          else
            url = send("admin_#{picture.picturable_type.downcase}_path", picture.picturable_id)
          end
          link_to picture.picturable_type, url
        end
        row("Image") { image_tag(picture.file.thumb('380x300#').url) }
      end
    end
  end
end
