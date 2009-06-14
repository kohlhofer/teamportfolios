module LayoutHelper
  
  def flash_class
    return "" if flash.values.empty?
    %{class = "#{flash.keys.join(' ')}"}
  end
  
  def flash_value
    flash.values.collect { | value | "<p>#{value}</p>"}.join("\n")
  end
  
  def htmltext(text)
    auto_link(simple_format(h(text)))
  end
end
