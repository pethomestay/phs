class AddAverageRatingToUser < ActiveRecord::Migration
  def up
    add_column :users, :average_rating, :integer
    add_index :users, :average_rating

    execute <<-SQL
      update users u set average_rating = (
        select sum(f.rating) / count(f.id)
        from feedbacks f
        where f.subject_id = u.id
        GROUP BY u.id
        );
    SQL

    execute 'update users set average_rating = 0 where average_rating is null;'
  end

  def down
    remove_index :users, :average_rating
    remove_column :users, :average_rating
  end
end
