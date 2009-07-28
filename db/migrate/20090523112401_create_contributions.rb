class CreateContributions < ActiveRecord::Migration
  def self.up
    create_table :contributions do |t|
      t.integer :project_id
      t.integer :user_id

      t.timestamps
    end
    Project.all.each do |project|
      User.all.each do |user|
        Contribution.create(:project_id=>project.id, :user_id=>user.id)
      end
    end
  end

  def self.down
    drop_table :contributions
  end
end
