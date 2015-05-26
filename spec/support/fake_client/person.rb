require_relative 'fake_client'

class Person < FakeClient
  PATH = 'people'

  attr_accessor :name, :address, :email, :address

  def path
    PATH
  end

  def self.path
    PATH
  end
end
