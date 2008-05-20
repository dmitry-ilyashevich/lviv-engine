# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Displays all flashes if any
  def flashes_if_any
    html = ''
    flash.each do |key,message|
      html << content_tag(:div, message, :id => key)
      html << content_tag(:script, :type => "text/javascript") do
        "new Effect.Pulsate('#{key.to_s}');new Effect.Fade('#{key.to_s}', { delay: 120 } );"
      end
    end
    html
  end

  def sexy_time_format(time)
    time.strftime('%d.%m.%Y')
  end

  def menu_item(text, url_opts, &block)
    current = false
    if url_opts[:action]
      current = controller.action_name == url_opts[:action] 
    else
      current = controller.controller_name == url_opts[:controller]
    end
    url = url_for(url_opts)
    if block_given? 
      content = capture(&block)
      concat("<li#{current ? ' class="menu-place"' : ''}><a href=\"#{url}\">#{text}</a>", block.binding)
      concat(content, block.binding) if current
      concat("</li>", block.binding)
    else
      menu_html = "<li#{current ? ' class="menu-place"' : ''}><a href=\"#{url}\">#{text}</a></li>"
    end
    menu_html
  end

  def sub_menu_item(text, url_opts)
    current = false
    if url_opts[:action]
      current = controller.action_name == url_opts[:action] 
    else
      current = controller.controller_name == url_opts[:controller]
    end
    url       = url_for(url_opts)
    menu_html = "<a href=\"#{url}\" #{current ? ' class="menu-place"' : ''}>#{text}</a>"
  end
  
  def links_to_languages(langs)  
    html = []
    langs.each do |lang|
      if controller.action_name 
        html << link_to( lang, :controller => controller.controller_name, :action => controller.action_name, :lang => lang)
      else 
        html << link_to( lang, :controller => controller.controller_name, :lang => lang)
      end
    end
    html.join(' ')
  end

end
