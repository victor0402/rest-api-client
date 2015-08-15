require 'active_model'
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
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    include Virtus.model(:nullify_blank => true)
    include ActiveModel::Conversion
    include ActiveModel::Validations

    PATH = ''
    SERVICE_KEY = ''

    attribute :id, Integer
    attribute :created_at, DateTime
    attribute :updated_at, DateTime

    def self.list(params = {})
      perform_get path, {:type => self, :params => params}
    end

    def self.count(params = {})
      perform_get "#{path}/count", {:params => params}
    end

    def self.find(id)
      perform_get "#{path}/#{id}", {:type => self}
    end

    def self.get(id)
      self.find id
    end

    def refresh
      response = perform_get "#{path}/#{id}", {:type => self.class}
      update_attributes(response)
      self
    end

    def save!
      return false unless valid?
      begin
        update_attributes(perform_post path, get_params)
        self
      rescue RestApiClient::ModelErrorsException => e
        errors.add(:rest_api_error, e.errors)
        raise e
      end
    end

    def save
      return false unless valid?

      begin
        update_attributes(perform_post path, get_params)
        self
      rescue RestApiClient::ModelErrorsException => e
        errors.add(:rest_api_error, e.errors)
        return false
      end
    end

    def delete
      perform_delete "#{path}/#{id}"
    end

    def update
      begin
        update_attributes(perform_put "#{path}/#{id}", get_params)
        self
      rescue RestApiClient::ModelErrorsException => e
        errors.add(:rest_api_error, e.errors)
        return false
      end
    end

    def update!
      begin
        update_attributes(perform_put "#{path}/#{id}", get_params)
        self
      rescue RestApiClient::ModelErrorsException => e
        errors.add(:rest_api_error, e.errors)
        raise e
      end
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

    protected

    def to_hash_params
      hash = {}
      self.attributes.each do |key, value|
        value_to_hash = value
        if value_to_hash && value_to_hash.is_a?(RestModel)
          hash["#{key}_id"] = value.id
          value_to_hash = value.to_hash_params
        end
        hash[key] = value_to_hash
      end
      hash
    end

    private

    def get_params
      {:type => self.class, :params => {get_model_name => self.to_hash_params}}
    end

    def update_attributes(response)
      self.attributes = response && response.is_a?(self.class) ? response.attributes : {}
    end

  end

end
