module Dimensions
  module Netutils extend ActiveSupport::Concern
    def url_connection_valid?
      uri       = URI.parse(url)
      http      = Net::HTTP.new(uri.host, uri.port)

      unless uri.respond_to?(:request_uri)
        self.errors.add(:url, 'The URI is not valid. Please check the url format')
        return false
      end

      request   = Net::HTTP::Get.new(uri.request_uri)
      response  = http.request(request)
      code      = response.code
      #response['content-type']
      if code == '200'
        true
      else
        self.errors.add(:url, 'Couldn\'t connect to the specified url. Please check the url you introduced is valid.')
        false
      end
    end
  end
end
