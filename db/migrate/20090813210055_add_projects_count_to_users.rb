class AddProjectsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :projects_count, :integer, :default => 0
    add_column :projects, :tasks_count, :integer, :default => 0
    
    User.reset_column_information
    User.find(:all).each do |u|
      User.update_counters u.id, :projects_count => u.projects.length
    end
    
  end
  
  def self.down
    remove_column :users, :projects_count
  end
end
