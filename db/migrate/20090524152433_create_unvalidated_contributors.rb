class CreateUnvalidatedContributors < ActiveRecord::Migration
  def self.up
    create_table :unvalidated_contributors do |t|
      t.integer :project_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :unvalidated_contributors
  end
end
