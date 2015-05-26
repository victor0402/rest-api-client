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
end

require_relative 'support/redis_mock'
include RedisMock

require_relative 'support/mock_requests'
include MockRequests