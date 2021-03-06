# see http://blog.new-bamboo.co.uk/2008/2/19/irregularscience
module IrregularScience
  def resize_within(w, h)
    r_old = width.to_f / height
    r_new = w.to_f / h
  
    w_new = r_new > r_old ? (h * r_old).to_i : w
    h_new = r_new > r_old ? h : (w / r_old).to_i
    
    self.resize(w_new, h_new) do |image|
      yield image
    end
  end
 
  def resize_exact(w, h, fromtop=true)
    r_old = width.to_f / height
    r_new = w.to_f / h
  
    w_crop = r_new > r_old ? width : (height * r_new).to_i
    h_crop = r_new > r_old ? (width / r_new).to_i : height
  
    trim_w = (width - w_crop) / 2
    l, r = trim_w, trim_w + w_crop
    
    if fromtop
      trim_h = 0
    else
      trim_h = (height - h_crop) / 2
    end
    t, b = trim_h, trim_h + h_crop
    
    self.with_crop(l, t, r, b) do |img|
      img.resize(w, h) do |thumb|
        yield thumb
      end
    end
  end
 
  def resize_to_width(w)
    scale = w.to_f / width
  
    img.resize(w, h*scale) do |image|
      yield image
    end
  end
 
  def resize_to_height(h)
    scale = h.to_f / height
  
    img.resize(w*scale, h) do |image|
      yield image
    end
  end
end
 
ImageScience.send(:include, IrregularScience)
