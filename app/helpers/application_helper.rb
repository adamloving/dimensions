module ApplicationHelper
  def entry_toggle_visibility_link(entry)
    message = entry.visible? ? "Hide" : "Show"
    link_to message, toggle_visible_admin_news_feed_feed_entry_path(entry.feed, entry), :method => :put
  end
end
