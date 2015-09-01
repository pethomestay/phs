class AddResponsivenessRateToUser < ActiveRecord::Migration
  def change
    add_column :users, :responsiveness_rate, :integer
  end
end
