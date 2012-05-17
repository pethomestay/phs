class AssociateSittersAndHotelsToUsers < ActiveRecord::Migration
  def change
    %w{hotels sitters}.each do |table|
      add_column table, :user_id, :integer
    end
  end
end
