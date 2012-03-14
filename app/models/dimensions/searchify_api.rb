class Dimensions::SearchifyApi
  def initialize
  end
   
  @@instance ||= IndexTank::Client.new(APP_CONFIG['searchify_api_url'])
 
  def self.instance
    return @@instance
  end
 
  def index(index_name)
    @@instance.indexes(name)
  end
 
  private_class_method :new
end

