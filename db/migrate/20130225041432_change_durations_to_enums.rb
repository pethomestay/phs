class ChangeDurationsToEnums < ActiveRecord::Migration
  def up
    add_column :enquiries, :duration_id, :integer
    execute "update enquiries set duration_id = 1 where duration = 'morning';"
    execute "update enquiries set duration_id = 2 where duration = 'afternoon';"
    execute "update enquiries set duration_id = 3 where duration = 'evening';"
    execute "update enquiries set duration_id = 4 where duration = 'overnight';"
    execute "update enquiries set duration_id = 5 where duration = '2nights';"
    execute "update enquiries set duration_id = 6 where duration = '3nights';"
    execute "update enquiries set duration_id = 7 where duration = '4nights';"
    execute "update enquiries set duration_id = 8 where duration = '5nights';"
    execute "update enquiries set duration_id = 9 where duration = '6nights';"
    execute "update enquiries set duration_id = 10 where duration = '7nights';"
    execute "update enquiries set duration_id = 11 where duration = 'longerthan7nights';"
    remove_column :enquiries, :duration

  end

  def down
    add_column :enquiries, :duration, :string
    execute "update enquiries set duration = 'morning' where  duration_id = 1 ;"
    execute "update enquiries set duration = 'afternoon' where  duration_id = 2 ;"
    execute "update enquiries set duration = 'evening'  where  duration_id = 3 ;"
    execute "update enquiries set duration = 'overnight' where  duration_id = 4 ;"
    execute "update enquiries set duration = '2nights' where  duration_id = 5 ;"
    execute "update enquiries set duration = '3nights' where  duration_id = 6 ;"
    execute "update enquiries set duration = '4nights' where  duration_id = 7 ;"
    execute "update enquiries set duration = '5nights' where  duration_id = 8 ;"
    execute "update enquiries set duration = '6nights' where  duration_id = 9 ;"
    execute "update enquiries set duration = '7nights' where duration_id = 10;"
    execute "update enquiries set duration = 'longerthan7nights' where duration_id = 11;"
    remove_column :enquiries, :duration_id
  end
end
