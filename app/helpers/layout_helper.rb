module LayoutHelper
  
  def flash_class
    return "" if flash.values.empty?
    %{class = "#{flash.keys.join(' ')}"}
  end
  
  def flash_value
    flash.values.collect { | value | "<p>#{value}</p>"}.join("\n")
  end
  
end
