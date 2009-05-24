class AddStraplineToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :strapline, :string
  end

  def self.down
    remove_column :projects, :strapline
  end
end
