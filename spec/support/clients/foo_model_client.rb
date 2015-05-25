require 'rest/api/client'

module FooModelClient
  class FooModel < RestApiClient::RestModel
    PATH = 'foo'

    def path
      PATH
    end

    def self.path
      PATH
    end

  end
end
