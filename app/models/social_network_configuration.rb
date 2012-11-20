# Site configuration model
class SocialNetworkConfiguration < ActiveRecord::Base
  TWITTER = 'twitter'
  TWITTER_DEFAULT_MESSAGE = 'King 5 News'

  def self.twitter_message
    where(name: TWITTER).first_or_initialize.message || TWITTER_DEFAULT_MESSAGE
  end
end
