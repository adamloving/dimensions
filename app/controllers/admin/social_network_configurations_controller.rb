class Admin::SocialNetworkConfigurationsController < Admin::BaseController
  def index
    @social_networks = SocialNetworkConfiguration.all
  end

  def update
    @social_network = SocialNetworkConfiguration.find(params[:id])

    if @social_network.update_attributes(params[:social_network_configuration])
      redirect_to admin_social_path
    end
  end
end
