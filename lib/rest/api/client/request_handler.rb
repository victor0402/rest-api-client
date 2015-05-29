require 'rest-client'
require 'json'
require 'redis'

module RestApiClient

  class RequestsHandler

    def self.perform_get(service_key, path, args = {:params => {}})
      RestClient.get(get_service_url(service_key) + path, args[:params]) { |response, request, result, &block|
        get_response_callback(args).call(response, request, result, &block)
      }
    end

    def self.perform_post(service_key, path, args = {})
      RestClient.post(get_service_url(service_key) + path, args[:params]) { |response, request, result, &block|
        get_response_callback(args).call(response, request, result, &block)
      }
    end

    def self.perform_put(service_key, path, args = {})
      RestClient.put(get_service_url(service_key) + path, args[:params]) { |response, request, result, &block|
        get_response_callback(args).call(response, request, result, &block)
      }
    end

    def self.perform_delete(service_key, path, args = {})
      RestClient.delete(get_service_url(service_key) + path, args[:params]) { |response, request, result, &block|
        get_response_callback(args).call(response, request, result, &block)
      }
    end

    def self.get_service_url(service_key)
      redis = Redis.new
      path = redis.get service_key
      raise RestApiClient::ServiceUrlException.new('You must need to set the service key') unless path
      path << '/' unless path.end_with?('/')
      path
    end

    def self.get_response_callback(args)
      lambda do |response, request, result, &block|
        if response.code >= 200 && response.code < 300
          RestApiClient.parse_json response, args

        elsif [301, 302, 307].include? response.code
          response.follow_redirection(request, result, &block)

        else
          response.return!(request, result, &block)
        end
      end
    end
  end
end