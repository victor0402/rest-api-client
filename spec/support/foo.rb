require 'rest/api/client'

class Foo < RestApiClient::RestModel
  SERVICE_KEY = 'foo_key'
  PATH = 'foo'

  def path
    PATH
  end

  def self.path
    PATH
  end

  # default service_key to instance methods
  def service_key
    SERVICE_KEY
  end

  # default service_key to class methods
  def self.service_key
    SERVICE_KEY
  end

end
