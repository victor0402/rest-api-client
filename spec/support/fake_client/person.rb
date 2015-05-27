require_relative 'fake_client'
require_relative 'address'

class Person < FakeClient
  PATH = 'people'

  attribute :name, String
  attribute :email, String
  attribute :address, Address

  def path
    PATH
  end

  def self.path
    PATH
  end
end
