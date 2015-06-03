require 'virtus'
require 'rest/api/client/version'
require 'rest/api/client/logger'
require 'rest/api/client/json_parser'
require 'rest/api/client/config'
require 'rest/api/exceptions/service_url_exception'
require 'rest/api/exceptions/unauthorized_exception'
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
      perform_get path, {:type => self.new}
    end

    def self.find(id)
      perform_get "#{path}/#{id}", {:type => self.new}
    end

    def self.get(id)
      self.find id
    end

    def save!
      saved_user = perform_post path, {:type => self.new, :params => {self.class.name.split('::').last.downcase => self.attributes}}
      self.attributes = saved_user ? saved_user.attributes : {}
    end

    def delete
      perform_delete "#{path}/#{id}"
    end

    def update!
      perform_put "#{path}/#{id}", {:type => self.new, :params => self.attributes}
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
