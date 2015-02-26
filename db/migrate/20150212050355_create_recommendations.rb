class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.references :user
      t.string :email
      t.text :review

      t.timestamps
    end
  end
end
