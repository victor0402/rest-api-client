require 'spec_helper'

describe RestApiClient::RequestsHandler do
  context 'get service url from redis' do
    let(:config) { {:log_level => 'verbose', :service_key => 'some-service.url'} }
    let(:service_url) { 'http://foo.bar' }

    before do
      RestApiClient.configure config

      @redis_mock = double(Redis)
      expect(Redis).to receive(:new).and_return(@redis_mock)
    end

    it 'gets the service url from redis using the config' do
      allow(@redis_mock).to receive(:get).with(config[:service_key]).and_return(service_url)
      url = RestApiClient::RequestsHandler.get_service_url
      expect(url).to eq service_url
    end

    it 'adds a slash in the end of the url' do
      allow(@redis_mock).to receive(:get).with(config[:service_key]).and_return(service_url)
      url = RestApiClient::RequestsHandler.get_service_url
      expect(url).to end_with '/'
    end

    it 'throws an error if the url is not defined in redis' do
      allow(@redis_mock).to receive(:get).with(config[:service_key]).and_return(nil)
      expect {
        RestApiClient::RequestsHandler.get_service_url
      }.to raise_error(RestApiClient::ServiceUrlException, 'You must need to set the service key')
    end
  end
end
