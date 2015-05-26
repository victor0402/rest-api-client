require 'spec_helper'
require_relative '../../support/foo'
require_relative '../../support/bar'

describe RestApiClient do
  it 'allow different configurations' do
    mock_redis_get Foo.service_key, 'foo.com'
    mock_redis_get Bar.service_key, 'bar.com'

    mock_request :get, 'foo.com/foo', {:body => 'foo return'}
    Foo.list

    mock_request :get, 'bar.com/bar', {:body => 'bar return'}
    Bar.list
  end
end
