require 'rest/api/client'

class User < RestApiClient::RestModel
  PATH = 'user'
  SERVICE_KEY = 'fake_service_key'

  attribute :first_name, String
  attribute :email, String
  attribute :password, String
  attribute :password_confirmation, String

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
