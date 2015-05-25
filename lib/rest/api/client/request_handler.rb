require 'rest-client'
require 'json'
require 'redis'

module RestApiClient
  class RequestsHandler

    def self.perform_get(path, args = {})
      RestClient.get(self.get_service_url + path, args) { |response, request, result, &block|
        get_response_callback.call(response, request, result, &block)
      }
    end

    def self.perform_post(path, args = {})
      RestClient.post(self.get_service_url + path, args) { |response, request, result, &block|
        get_response_callback.call(response, request, result, &block)
      }
    end

    def self.perform_put(path, args = {})
      RestClient.put(self.get_service_url + path, args) { |response, request, result, &block|
        get_response_callback.call(response, request, result, &block)
      }
    end

    def self.perform_delete(path, args = {})
      RestClient.delete(self.get_service_url + path, args) { |response, request, result, &block|
        get_response_callback.call(response, request, result, &block)
      }
    end

    def self.get_service_url
      redis = Redis.new
      path = redis.get RestApiClient.config[:service_key]
      raise RestApiClient::ServiceUrlException.new('You must need to set the service key') unless path
      path << '/' unless path.end_with?('/')
      path
    end

    def self.grab_data(json_response)
      json_response.match(/(?<="data":)(\{|\[).*(\}|\])(?=(\}|\,))/).to_s
    end

    def self.get_response_callback
      lambda do |response, request, result, &block|
        @access_token = result.header['access-token']
        @uid = result.header['uid']
        if response.code >= 200 && response.code < 300
          hash_params = JSON.parse grab_data(response)
          if hash_params.kind_of?(Hash)
            hash_params.each { |k, v| send("#{k}=", v) }
          end
          self

        elsif [301, 302, 307].include? response.code
          response.follow_redirection(request, result, &block)

        else
          response.return!(request, result, &block)
        end
      end
    end
  end
end