require 'spec_helper'

describe RestApiClient do
  context '.configuration' do
    it 'has a default configuration' do
      expect(RestApiClient.config).to eq({:log_level => 'verbose', :service_key => ''})
    end

    it 'allows a new configuration through hash' do
      new_config = {:log_level => 'warning', :service_key => 'some_service_key'}
      RestApiClient.configure new_config
      expect(RestApiClient.config).to eq new_config
    end

    it 'allows a new configuration through yaml file' do
      path_to_config = 'spec/support/api_config.yaml'
      RestApiClient.configure_with path_to_config
      expect(RestApiClient.config).to eq({:log_level => 'debug', :service_key => 'a_key'})
    end

  end

  context '.configure_authorization' do
    let(:client_name) { 'foo_client' }
    let(:client_key) { 'foo_client_key' }

    let(:client2_name) { 'foo_client2' }
    let(:client2_key) { 'foo_client_key2' }

    context 'with one client' do
      it 'allows to add an authorization_key' do
        RestApiClient.configure_authorization client_name, client_key
        expect(RestApiClient.get_auth_key client_name).to eq client_key
      end
    end

    context 'with multiple clients' do
      it 'allows multiple authorization configs' do
        RestApiClient.configure_authorization client_name, client_key
        RestApiClient.configure_authorization client2_name, client2_key

        expect(RestApiClient.get_auth_key client_name).to eq client_key
        expect(RestApiClient.get_auth_key client2_name).to eq client2_key
      end
    end
  end
end
