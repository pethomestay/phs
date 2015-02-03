class AddPrivateReviewToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :private_review, :text
  end
end
