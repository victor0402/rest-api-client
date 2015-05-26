require 'rest-client'
require 'json'
require 'redis'

module RestApiClient
  class RequestsHandler

    def self.perform_get(service_key, path, args = {})
      RestClient.get(get_service_url(service_key) + path, args) { |response, request, result, &block|
        get_response_callback.call(response, request, result, &block)
      }
    end

    def self.perform_post(service_key, path, args = {})
      RestClient.post(get_service_url(service_key) + path, args) { |response, request, result, &block|
        get_response_callback.call(response, request, result, &block)
      }
    end

    def self.perform_put(service_key, path, args = {})
      RestClient.put(get_service_url(service_key) + path, args) { |response, request, result, &block|
        get_response_callback.call(response, request, result, &block)
      }
    end

    def self.perform_delete(service_key, path, args = {})
      RestClient.delete(get_service_url(service_key) + path, args) { |response, request, result, &block|
        get_response_callback.call(response, request, result, &block)
      }
    end

    def self.get_service_url(service_key)
      redis = Redis.new
      path = redis.get service_key
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
          json_response = JSON.parse response
          json_data = {}
          if json_response.kind_of?(Hash) && json_response.has_key?('data')
            json_data = json_response['data']
          end

          objects = Array.new

          if json_data.kind_of?(Array)
            json_data.each { |data|
              current_person = Person.new
              data.each { |k, v|
                current_person.send("#{k}=", v)
              }
              objects.push(current_person)
            }
          end

          # if hash_data.kind_of?(Hash)
          #   hash_data.each { |k, v|
          #     send("#{k}=", v)
          #
          #   }
          #
          # end
          objects

        elsif [301, 302, 307].include? response.code
          response.follow_redirection(request, result, &block)

        else
          response.return!(request, result, &block)
        end
      end
    end
  end
end