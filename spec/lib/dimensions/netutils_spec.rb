require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Dimensions::Netutils do

  describe "" do
    before do
      Object.send(:include, Dimensions::Netutils)
      @testable = Object.new
      @testable.stub(:url){'/some_url'}
      uri = mock(host: 'host', port: 80, request_uri: '/some-uri')
      URI.stub(:parse).with(@testable.url){uri}
      http = mock
      Net::HTTP.stub(:new).with(uri.host, uri.port){http}
      req = mock
      Net::HTTP::Get.stub(:new).with(uri.request_uri){req}
      @resp = mock
      http.stub(:request).with(req){@resp}
    end

    describe "should have scorePublicContest method" do
      it "should return true when the connection is valid" do
        @resp.stub(:code){'200'}
        @testable.url_connection_valid?.should be_true
      end

      it "should add a message to the errors when the connection is unsuccessful" do
        @resp.stub(:code){500}
        errors = mock
        @testable.stub(:errors){errors}
        errors.should_receive(:add).with(:url, 'Couldn\'t connect to the specified url. Please check the url you introduced is valid.'){nil}
        @testable.url_connection_valid?.should be_false
      end
    end
  end

  describe 'with an invalid uri (does not respond to request uri)' do
    before do
      Object.send(:include, Dimensions::Netutils)
      @testable = Object.new
      @testable.stub(:url){'/some_url'}
      uri = mock(host: 'host', port: 80) # DOES NOT RESPOND TO request_uri!!!
      URI.stub(:parse).with(@testable.url){uri}
      http = mock
      Net::HTTP.stub(:new).with(uri.host, uri.port){http}
      req = mock
    end

    it "should add a message to the errors wit this warning" do
      errors = mock
      @testable.stub(:errors){errors}
      errors.should_receive(:add).with(:url, 'The URI is not valid. Please check the url format'){nil}
      @testable.url_connection_valid?.should be_false
    end
  end
end

