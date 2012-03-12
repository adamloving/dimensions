module ApplicationHelper
    def entry_toggle_visibility_link(entry,opts={})
    message = entry.visible? ? "Hide" : "Show"
    link_to message, toggle_visible_admin_news_feed_feed_entry_path(entry.feed, entry), :method => :put, :class => opts[:class]
    end

    def title_layout(object)
      if object.has_key?:id
        ActiveSupport::Inflector.titleize(object[:controller].gsub!("admin/"," ")).singularize.split(' ').join(' - ')
      else
        ActiveSupport::Inflector.titleize(object[:controller].gsub!("admin/"," ")).pluralize.split(' ').join(' - ')
      end
    end

    def set_nav_active(path)
   "current" if current_page?(path)
  end

  def layout_by_resource
    if devise_controller?
      "admin"
    else
      "application"
    end
  end

  def after_sign_out_path_for(resource_or_scope)
     request.referrer
  end

end
