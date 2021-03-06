require 'rest-client'
require 'json'
require 'redis'
require 'addressable/uri'

module RestApiClient

  class RequestsHandler

    def self.perform_get(service_key, path, args = {:params => {}}, headers = {})
      self.do_request_without_payload('get', service_key, path, args, headers)
    end

    def self.perform_delete(service_key, path, args = {:params => {}}, headers = {})
      self.do_request_without_payload('delete', service_key, path, args, headers)
    end

    def self.perform_post(service_key, path, args = {:params => {}}, headers = {})
      self.do_request_with_payload('post', service_key, path, args, headers)
    end

    def self.perform_put(service_key, path, args = {:params => {}}, headers = {})
      self.do_request_with_payload('put', service_key, path, args, headers)
    end

    def self.do_request_with_payload(method, service_key, path, args = {:params => {}}, headers = {})
      headers = treat_header headers, service_key
      url = get_service_url(service_key) + path

      res = RestClient::Resource.new(url)
      res.method(method).call(args[:params], headers) { |response, request, result, &block|
        get_response_callback(args).call(response, request, result, &block)
      }
    end

    def self.do_request_without_payload(method, service_key, path, args = {:params => {}}, headers = {})
      headers = treat_header headers, service_key
      url = get_service_url(service_key) + path + '?' + params_to_query(args[:params])

      res = RestClient::Resource.new(url)
      res.method(method).call(headers) { |response, request, result, &block|
        get_response_callback(args).call(response, request, result, &block)
      }
    end

    def self.treat_header(headers, service_key)
      authorization_key = RestApiClient.get_auth_key service_key
      if authorization_key
        headers = headers.merge(:Authorization => authorization_key)
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

        elsif response.code == 401
          raise RestApiClient::UnauthorizedException.new RestApiClient.parse_json response

        elsif response.code >= 400 && response.code < 500
          response = RestApiClient.parse_json response
          message = response.has_key?('message') ? response['message'] : ''
          raise RestApiClient::ModelErrorsException.new message

        else
          response.return!(request, result, &block)
        end
      end
    end

    def self.params_to_query(params)
      uri = Addressable::URI.new
      uri.query_values = params
      uri.query || ''
    end
  end
end