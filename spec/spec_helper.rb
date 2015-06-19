require 'simplecov'
# cobertura dos testes
SimpleCov.start do

  # ignorar pastas
  add_filter 'spec/'
  add_filter 'bin/'

  # grupo de arquivos
  add_group 'lib', 'lib'
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'factory_girl'
require 'webmock/rspec'
require 'rest/api/client'

require 'bundler/setup'
Bundler.setup

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.after(:all) do
    WebMock.allow_net_connect!
  end
end

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

require_relative 'support/redis_mock'
include RedisMock

require_relative 'support/mock_requests'
include MockRequests

# travis https://travis-ci.org/victor0402/rest-api-client
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

