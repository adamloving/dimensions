class HomeController < ApplicationController
  def index
    @twitter_message = SocialNetworkConfiguration.find_by_name('twitter').message
  end
  
  def launch
    render :layout => 'launch'
  end
end
