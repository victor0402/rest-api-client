require 'rest-client'
require 'json'
require 'redis'
require 'addressable/uri'

module RestApiClient

  class RequestsHandler

    def self.perform_get(service_key, path, args = {:params => {}}, headers = {})
      uri = Addressable::URI.new
      uri.query_values = args[:params]
      url = get_service_url(service_key) + path + '?' + uri.query
      headers = treat_header headers

      RestClient.get(url, headers) { |response, request, result, &block|
        get_response_callback(args).call(response, request, result, &block)
      }
    end

    def self.perform_post(service_key, path, args = {:params => {}}, headers = {})
      self.do_request('post', service_key, path, args, headers)
    end

    def self.perform_put(service_key, path, args = {:params => {}}, headers = {})
      self.do_request('put', service_key, path, args, headers)
    end

    def self.perform_delete(service_key, path, args = {:params => {}}, headers = {})
      self.do_request('delete', service_key, path, args, headers)
    end

    def self.do_request(method, service_key, path, args = {:params => {}}, headers = {})
      headers = treat_header headers
      url = get_service_url(service_key) + path
      RestClient.method(method).call(url, args[:params], headers) { |response, request, result, &block|
        get_response_callback(args).call(response, request, result, &block)
      }
    end

    def self.treat_header(headers)
      authorization_key = RestApiClient.get_auth_key service_key
      if authorization_key
        headers.merge(:Authorization => authorization_key)
      end
      headers
    end

    def self.get_service_url(service_key)
      redis = Redis.new
      path = redis.get "#{service_key}.url"
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