class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.belongs_to :user
      t.string :content_type, :filename, :thumbnail, :caption
      t.integer :size, :width, :height, :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
