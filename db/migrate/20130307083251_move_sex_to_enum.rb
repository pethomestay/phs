class MoveSexToEnum < ActiveRecord::Migration
  def up
    add_column :pets, :sex_id, :integer
    execute "update pets set sex_id = 1 where sex = 'male_desexed'"
    execute "update pets set sex_id = 2 where sex = 'female_desexed'"
    execute "update pets set sex_id = 3 where sex = 'male_entire'"
    execute "update pets set sex_id = 4 where sex = 'female_entire'"
    remove_column :pets, :sex
  end

  def down
    add_column :pets, :sex, :string
    execute "update pets set sex = 'male_desexed'  where   sex_id = 1"
    execute "update pets set sex = 'female_desexed' where sex_id = 2"
    execute "update pets set sex = 'male_entire'   where   sex_id = 3"
    execute "update pets set sex = 'female_entire' where   sex_id = 4"
    remove_column :pets, :sex_id
  end
end
