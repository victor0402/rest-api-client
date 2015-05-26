require 'spec_helper'

describe RestApiClient::RequestsHandler do
  context 'get service url from redis' do
    let(:config) { {:log_level => 'verbose', :service_key => 'some-service.url'} }
    let(:service_url) { 'http://foo.bar' }

    before do
      RestApiClient.configure config

    end

    it 'gets the service url from redis using the config' do
      mock_redis_get config[:service_key], service_url
      url = RestApiClient::RequestsHandler.get_service_url config[:service_key]
      expect(url).to eq service_url
    end

    it 'adds a slash in the end of the url' do
      mock_redis_get config[:service_key], service_url
      url = RestApiClient::RequestsHandler.get_service_url config[:service_key]
      expect(url).to end_with '/'
    end

    it 'throws an error if the url is not defined in redis' do
      mock_redis_get config[:service_key]
      expect {
        RestApiClient::RequestsHandler.get_service_url config[:service_key]
      }.to raise_error(RestApiClient::ServiceUrlException, 'You must need to set the service key')
    end
  end
end
