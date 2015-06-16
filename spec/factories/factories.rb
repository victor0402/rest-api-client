require_relative '../support/user'

FactoryGirl.define do

  factory :user, class: User do |u|
    u.first_name { 'Test' }
    u.email { 'test@test.com' }
    u.password { '123456789' }
    u.password_confirmation { '123456789' }
  end
end