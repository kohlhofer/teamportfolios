class FixImagesToProjects < ActiveRecord::Migration
  def self.up
    rename_column :images, :user_id, :project_id
  end

  def self.down
    rename_column :images, :project_id, :user_id
  end
end
