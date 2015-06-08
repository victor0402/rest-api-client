require 'virtus'
require 'rest/api/client/version'
require 'rest/api/client/logger'
require 'rest/api/client/json_parser'
require 'rest/api/client/config'
require 'rest/api/exceptions/service_url_exception'
require 'rest/api/exceptions/unauthorized_exception'
require 'rest/api/exceptions/model_errors_exception'
require 'rest/api/client/request_handler'

module RestApiClient

  class RestModel
    include Virtus.model

    PATH = ''
    SERVICE_KEY = ''

    attribute :id, Integer
    attribute :created_at, Date
    attribute :updated_at, Date

    def self.list
      perform_get path, {:type => self}
    end

    def self.find(id)
      perform_get "#{path}/#{id}", {:type => self}
    end

    def self.get(id)
      self.find id
    end

    def save!
      klazz = self.class
      response = perform_post path, {:type => klazz, :params => {get_model_name => self.attributes}}
      self.attributes = response && response.is_a?(klazz) ? response.attributes : {}
    end

    def delete
      perform_delete "#{path}/#{id}"
    end

    def update!
      perform_put "#{path}/#{id}", {:type => self.class, :params => self.attributes}
    end

    def perform_get(path, args = {}, headers = {})
      RequestsHandler.perform_get(service_key, path, args, headers)
    end

    def perform_post(path, args = {}, headers = {})
      RequestsHandler.perform_post(service_key, path, args, headers)
    end

    def perform_put(path, args = {}, headers = {})
      RequestsHandler.perform_put(service_key, path, args, headers)
    end

    def perform_delete(path, args = {}, headers = {})
      RequestsHandler.perform_delete(service_key, path, args, headers)
    end

    def self.perform_get(path, args = {}, headers = {})
      RequestsHandler.perform_get(service_key, path, args, headers)
    end

    def get_model_name
      self.class.name.split('::').last.downcase
    end

    def self.get_model_name
      self.name.split('::').last.downcase
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

    def ==(other)
      id == other.id
    end

  end

end
