class CreateProjectLinks < ActiveRecord::Migration
  def self.up
    create_table :project_links do |t|
      t.integer :project_id
      t.string :url
      t.string :label
      t.timestamps
    end
    remove_column :projects, :homepage
  end

  def self.down
    drop_table :project_links
    add_column :projects, :homepage, :string     
  end
end
