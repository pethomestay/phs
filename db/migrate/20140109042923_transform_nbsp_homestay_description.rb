class TransformNbspHomestayDescription < ActiveRecord::Migration
  def self.up
    sql = "update homestays set description = replace(description, '&nbsp;', ' ')"
    ActiveRecord::Base.connection.update(sql)
  end
end
