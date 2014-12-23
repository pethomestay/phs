class AddResponsivenessScoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :responsiveness_score, :decimal
  end
end
