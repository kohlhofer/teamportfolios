class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.string :title
      t.text :description
      t.string :homepage

      t.timestamps
    end
    
    Project.create(
      :name=>'sample_project', 
      :title=>'Sample Project', 
      :description=>'some project or other',
      :homepage=>'http://somewhereelse.com')
  end

  def self.down
    drop_table :projects
  end
end
