class AddSlugToHomestays < ActiveRecord::Migration
  def change
    add_column :homestays, :slug, :string
  end
end
