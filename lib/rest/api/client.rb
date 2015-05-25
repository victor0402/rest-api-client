require 'rest/api/client/version'
require 'rest/api/client/config'
require 'rest/api/exceptions/service_url_exception'
require 'rest/api/client/request_handler'

module RestApiClient

  class RestModel

    PATH = ''
    SERVICE_KEY = ''

    attr_accessor :id

    def initialize(args = {})
      args.each do |k, v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end if args.is_a? Hash
    end

    def self.list
      self.perform_get path
    end

    def save
      perform_post path
    end

    def delete
      perform_delete "#{path}/#{id}"
    end

    def update
      perform_put "#{path}/#{id}"
    end

    def perform_get(path, args = {})
      RequestsHandler.perform_get(service_key, path, args)
    end

    def perform_post(path, args = {})
      RequestsHandler.perform_post(service_key, path, args)
    end

    def perform_put(path, args = {})
      RequestsHandler.perform_put(service_key, path, args)
    end

    def perform_delete(path, args = {})
      RequestsHandler.perform_delete(service_key, path, args)
    end

    def self.perform_get(path, args = {})
      RequestsHandler.perform_get(service_key, path, args)
    end

    # default service_key to instance methods
    def service_key
      SERVICE_KEY
    end

    # default service_key to class methods
    def self.service_key
      SERVICE_KEY
    end

    # default path to instance methods
    def path
      PATH
    end

    # default path to class methods
    def self.path
      PATH
    end
  end

end
