require 'rest/api/client/version'
require 'rest/api/client/config'
require 'rest/api/exceptions/service_url_exception'
require 'rest/api/client/request_handler'

module RestApiClient

  def self.perform_get(path, args = {})
    RequestsHandler.perform_get(path, args)
  end

  def perform_get(path, args = {})
    RequestsHandler.perform_get(path, args)
  end

  def self.perform_post(path, args = {})
    RequestsHandler.perform_post(path, args)
  end

  def perform_post(path, args = {})
    RequestsHandler.perform_post(path, args)
  end

  def self.perform_put(path, args = {})
    RequestsHandler.perform_put(path, args)
  end

  def perform_put(path, args = {})
    RequestsHandler.perform_put(path, args)
  end

  def self.perform_delete(path, args = {})
    RequestsHandler.perform_delete(path, args)
  end

  def perform_delete(path, args = {})
    RequestsHandler.perform_delete(path, args)
  end

end
