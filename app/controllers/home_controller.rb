class HomeController < ApplicationController
  def index
    @social_network_configuration = SocialNetworkConfiguration.twitter_message
  end

  def launch
    render :layout => 'launch'
  end
end
