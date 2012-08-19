class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :user
      t.references :subject
      t.references :enquiry
      t.integer :rating
      t.text :review

      t.timestamps
    end
    add_index :feedbacks, :user_id
    add_index :feedbacks, :subject_id
    add_index :feedbacks, :enquiry_id
  end
end
