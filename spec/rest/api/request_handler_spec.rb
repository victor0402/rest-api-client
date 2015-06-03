require 'spec_helper'
require_relative '../../support/foo'
require_relative '../../support/bar'


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

  describe 'requests' do
    let(:service_key) { Foo.service_key }
    let(:service_url) { 'http://foo.bar' }
    let(:auth_key) { 'key' }

    context '.do_request_with_payload' do
      it 'sends the authorization_key in the headers if it is configured' do
        mock_request :post, "#{service_url}/", nil, {:Authorization => auth_key}
        RestApiClient.configure_authorization service_key, auth_key
        mock_redis_get service_key, service_url

        RestApiClient::RequestsHandler.do_request_with_payload('post', service_key, '')
      end
    end

    context '.do_request_without_payload' do
      it 'sends the authorization_key in the headers if it is configured' do
        mock_request :get, "#{service_url}/", nil, {:Authorization => auth_key}
        RestApiClient.configure_authorization service_key, auth_key
        mock_redis_get service_key, service_url

        RestApiClient::RequestsHandler.do_request_without_payload('get', service_key, '')
      end
    end

    context '.perform_get' do
      it 'parse the params and append it in the url' do
        mock_request :get, "#{service_url}/people?id=123&foo=bar"
        mock_redis_get service_key, service_url
        RestApiClient::RequestsHandler.perform_get(service_key, 'people', {:params => {:id => 123, :foo => 'bar'}})
      end
    end

    context '.perform_delete' do
      it 'parse the params and append it in the url' do
        mock_request :delete, "#{service_url}/people?id=123&foo=bar"
        mock_redis_get service_key, service_url
        RestApiClient::RequestsHandler.perform_delete(service_key, 'people', {:params => {:id => 123, :foo => 'bar'}})
      end
    end

    context '.perform_post' do
      it 'send the params in the body' do
        mock_request :post, "#{service_url}/people", nil, nil, {:created_at => '', :id => '123'}
        mock_redis_get service_key, service_url
        RestApiClient::RequestsHandler.perform_post(service_key, 'people', {:params => {'created_at' => '', 'id' => '123'}})
      end

      it 'uses the authorization_key if it is configured' do
        RestApiClient.configure_authorization service_key, auth_key

        mock_request :post, "#{service_url}/people", nil, {:Authorization => auth_key}, {:created_at => '', :id => '123'}
        mock_redis_get service_key, service_url
        RestApiClient::RequestsHandler.perform_post(service_key, 'people', {:params => {'created_at' => '', 'id' => '123'}})
      end
    end

    context '.perform_put' do
      it 'send the params in the body' do
        mock_request :put, "#{service_url}/people", nil, nil, {:created_at => '', :id => '123'}
        mock_redis_get service_key, service_url
        RestApiClient::RequestsHandler.perform_put(service_key, 'people', {:params => {'created_at' => '', 'id' => '123'}})
      end

      it 'uses the authorization_key if it is configured' do
        RestApiClient.configure_authorization service_key, auth_key

        mock_request :put, "#{service_url}/people", nil, {:Authorization => auth_key}, {:created_at => '', :id => '123'}
        mock_redis_get service_key, service_url
        RestApiClient::RequestsHandler.perform_put(service_key, 'people', {:params => {'created_at' => '', 'id' => '123'}})
      end
    end
  end


end
