class AddAdditionalBooleansToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :fenced, :boolean, default: false
    add_column :homestays, :supervision_outside_work_hours, :boolean, default: false
    add_column :homestays, :police_check, :boolean, default: false
  end
end
