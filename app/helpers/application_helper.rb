module ApplicationHelper
    def entry_toggle_visibility_link(entry,opts={})
    message = entry.visible? ? "Hide" : "Show"
    link_to message, toggle_visible_admin_news_feed_feed_entry_path(entry.feed, entry), :method => :put,:class => opts[:class]
  end
  def title_layout(object)
    unless object.nil?
      if object.is_a?Array
        object.first.class.name
      else
        object.class 
      end
    end
  end

  def set_nav_active(path)
   "current" if current_page?(path)
  end

end
