require_relative '../support/user'
require_relative '../support/fake_client/person'
require_relative '../support/fake_client/address'

FactoryGirl.define do

  factory :user, class: User do |u|
    u.first_name { 'Test' }
    u.email { 'test@test.com' }
    u.password { '123456789' }
    u.password_confirmation { '123456789' }
  end

  factory :user_with_invalid_password, class: User do |u|
    u.first_name { 'Test' }
    u.email { 'test@test.com' }
    u.password { '123' }
    u.password_confirmation { '123' }
  end

  factory :address, class: Address do |u|
    u.street { 'x' }
  end

  factory :person, class: Person do |u|
    u.name { 'Test' }
    u.email { 'test@test.com' }
  end
end