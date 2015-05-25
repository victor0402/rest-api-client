require 'rest/api/client/version'
require 'rest/api/client/config'

module RestApiClient
  @relative_path

  def initialize(relative_path)
    @relative_path = relative_path
  end

  def self.perform_get(path, args = {})
    RestClient.get self.get_service_url + path, args
  end

  def perform_get(path, args = {})

  end

  private

  # TODO - tratar o final da URL (com '/' ou sem)
  def get_service_url
    redis = Redis.new
    redis.get RestApiClient.config[:service_key]
  end

end
