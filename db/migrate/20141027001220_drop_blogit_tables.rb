class DropBlogitTables < ActiveRecord::Migration
  def up
    drop_table :blog_posts
    drop_table :blog_comments
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
