require_relative 'fake_client'
class Address < FakeClient
  PATH = 'addresses'

  attribute :street, String
  attribute :city, String
  attribute :state, String

  def path
    PATH
  end

  def self.path
    PATH
  end
end