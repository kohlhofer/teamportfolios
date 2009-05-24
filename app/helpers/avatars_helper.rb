module AvatarsHelper

  def avatar_for(user, size=:small) 
    image_tag(avatar_filename(user, size), :class => "profile_avatar")
  end
  
  def link_to_avatar_for(user, size=:small, html_options = {}) 
    link_to(avatar_for(user, size), user, html_options)
  end
  
  def avatar_filename(user, size=:small) 
    if user.avatar
      user.avatar.public_filename(size)
    else 
      "default_avatar_#{size}.png"
    end 
  end
  
end