require 'yaml'
#require 'rake'
#load File.join(Rails.root, "lib", "tasks", "tweet_stream.rake")

credentials = YAML.load_file(File.join("#{Rails.root}", "config", "app_config.yml"))

TweetStream.configure do |config|
  config.consumer_key       = credentials["twitter"]["consumer_key"]
  config.consumer_secret    = credentials["twitter"]["consumer_secret"]
  config.oauth_token        = credentials["twitter"]["oauth_token"]
  config.oauth_token_secret = credentials["twitter"]["oauth_token_secret"]
  config.auth_method        = :oauth
end
