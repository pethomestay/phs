class CreateApiTokens < ActiveRecord::Migration

  def change
    create_table :api_tokens do |t|
      t.string :name, limit: 50
      t.string :code, limit: 36
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :api_tokens, :code
  end

end
