class AddStraplineToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :strapline, :string
  end

  def self.down
    remove_column :users, :strapline
  end
end
