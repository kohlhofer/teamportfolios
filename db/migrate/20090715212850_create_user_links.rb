class CreateUserLinks < ActiveRecord::Migration
  def self.up
    create_table :user_links do |t|
      t.integer :user_id
      t.string :url
      t.string :label
      t.timestamps
    end
  end

  def self.down
    drop_table :user_links
  end
end
