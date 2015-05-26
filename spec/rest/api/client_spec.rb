require 'spec_helper'
require_relative '../../support/foo'
require_relative '../../support/bar'
require_relative '../../support/fake_client/person'
require_relative '../../support/fake_client/address'

describe RestApiClient do
  it 'allow different clients' do
    mock_redis_get Foo.service_key, 'foo.com'
    mock_request :get, 'foo.com/foo'
    Foo.list

    mock_redis_get Bar.service_key, 'bar.com'
    mock_request :get, 'bar.com/bar'
    Bar.list
  end

  describe '.List' do
    let(:service_url) { 'http://fake-service.com' }

    before(:each) do
      mock_redis_get Person.service_key, service_url
    end

    it 'should fetch all people' do
      mock_request :get, "#{service_url}/people", 'people_response.txt'
      people = Person.list
      expect(people).to_not be_nil
    end
  end
end
