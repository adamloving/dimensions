module ApplicationHelper
    def entry_toggle_visibility_link(entry,opts={})
    message = entry.visible? ? "Hide" : "Show"
    link_to message, toggle_visible_admin_news_feed_feed_entry_path(entry.feed, entry), :method => :put, :class => opts[:class]
    end

    def title_layout(object)
      if object.has_key?:id
        ActiveSupport::Inflector.titleize(object[:controller].gsub!("admin/"," ")).singularize.split(' ').join
      else
        ActiveSupport::Inflector.titleize(object[:controller].gsub!("admin/"," ")).pluralize.split(' ').join
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

  def entries_states_for_select
    [" "] + FeedEntry.state_machine.states.map{|state| state.name.to_s}
  end

  def feed_entry_opengraph_metas(feed_entry)
    res = build_opengraph_meta "og:title", feed_entry.name
    res +=build_opengraph_meta "og:type", "website" 
    res +=build_opengraph_meta "og:image", "http://blog-assets.bigfishgames.com/News/King5.jpg" 
    res +=build_opengraph_meta "og:url", news_path(feed_entry)
    res +=build_opengraph_meta "og:site_name", "King5 Dimensions"
    res +=build_opengraph_meta "fb:app_id", APP_CONFIG['fb_app_id']
    res
  end

  def build_opengraph_meta(property, value)
    content_tag :meta, nil, :property => property, :content => value
  end
end
