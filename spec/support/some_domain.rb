require 'rest/api/client'
class SomeDomain < RestApiClient::RestModel
  PATH = 'some_domain'

  def path
    PATH
  end

  def self.path
    PATH
  end

end