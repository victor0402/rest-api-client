require_relative 'fake_client'
class Address < FakeClient
  PATH = 'addresses'

  attr_accessor :street, :city, :state

  def path
    PATH
  end

  def self.path
    PATH
  end
end