require 'resque/server'

class SecureResqueServer < Resque::Server
  before do
    redirect '/admin/login' unless request.env['warden'].user.present? && request.env['warden'].user.is_a?(AdminUser)
  end
end

