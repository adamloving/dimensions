class Entity < ActiveRecord::Base
  has_and_belongs_to_many  :feed_entries
  has_and_belongs_to_many  :news_feeds

  serialize   :serialized_data, Hash

  # we fucked up with the naming of the STI names.
  Entity.inheritance_column= "ruby_type"

  scope     :location, where(:type => "location")
  scope     :primary, where(:default => true)
  scope     :secondary, where(:default => false)

  validates :name, :uniqueness => {:scope => :type}
end
