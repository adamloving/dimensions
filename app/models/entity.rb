class Entity < ActiveRecord::Base

  has_many  :feed_entries, :through => :entity_feed_entries
  has_many  :entity_feed_entries
  has_and_belongs_to_many :news_feeds


  serialize   :serialized_data, Hash
  serialize   :tags, Array

  # we fucked up with the naming of the STI names.
  Entity.inheritance_column= "ruby_type"

  scope     :location, where(:type => "location")
  scope     :primary, where(:default => true)
  scope     :secondary, where(:default => false)
  scope     :tag, where(:type => "tag")

  validates :name, :uniqueness => {:scope => :type}

  def clear_tag(name)
    return false if self.tags.blank? || self.type != 'tag'
    self.tags.delete(name)
  end


  def as_twitter_tag_list
    return nil if self.tags.blank? || self.type != 'tag'
    twitags = self.tags.map{|tag| '#' + tag.titleize.gsub(' ', '')}
    twitags.uniq
  end
end
