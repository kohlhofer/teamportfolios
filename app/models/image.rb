class Image < ActiveRecord::Base
  belongs_to :project
  has_attachment(
    :content_type => :image, :storage => :file_system, :path_prefix=>'public/project_images',
    :thumbnails => { :small => '160x90', :medium => '280' }, 
    :max_size => 5.megabytes, :processor => 'ImageScience')
  validates_as_attachment

  def attachment_attributes_valid?
    errors.add_to_base("Uploaded file is too large (5MB max).") if attachment_options[:size] && !attachment_options[:size].include?(send(:size))
    errors.add_to_base("Uploaded file has invalid content.") if attachment_options[:content_type] && !attachment_options[:content_type].include?(send(:content_type))
  end
  
#  def resize_image(img, size)
#    img.crop_resized(size, size)
#    self.temp_path = write_to_temp_file(img.to_blob)
#  end

end
