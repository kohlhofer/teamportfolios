class RegenerateThumbnails2 < ActiveRecord::Migration
  def self.up
    Image.all.each{|img| img.save if img.parent_id.nil?}
  end

  def self.down
  end
end
