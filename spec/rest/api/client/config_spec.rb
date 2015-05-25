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

    it 'allows only known keys' do
      new_config = {:log_level => 'warning', :service_key => 'some_service_key', :some_key => 'some_value'}
      RestApiClient.configure new_config
      expect(RestApiClient.config).to_not have_key(:some_key)
    end
  end
end
