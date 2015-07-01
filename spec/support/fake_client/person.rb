require_relative 'fake_client'
require_relative 'address'

class Person < FakeClient
  PATH = 'people'

  attribute :name, String
  attribute :email, String
  attribute :address, Address

  validates :name, presence: true

  def path
    PATH
  end

  def self.path
    PATH
  end

  def ==(other)
    super && name == other.name && email == other.email && address == other.address
  end


end
