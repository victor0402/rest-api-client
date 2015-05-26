require 'rest/api/client'

class FakeClient < RestApiClient::RestModel
  SERVICE_KEY = 'fake_service_key'

  # default service_key to instance methods
  def service_key
    SERVICE_KEY
  end

  # default service_key to class methods
  def self.service_key
    SERVICE_KEY
  end

end
