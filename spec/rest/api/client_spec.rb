require 'spec_helper'
require_relative '../../support/foo'
require_relative '../../support/bar'
require_relative '../../support/fake_client/person'
require_relative '../../support/fake_client/address'
require_relative '../../support/user'

describe RestApiClient do
  let(:service_url) { 'http://fake-service.com' }

  it 'allow different clients' do
    mock_redis_get Foo.service_key, 'foo.com'
    mock_request :get, 'foo.com/foo'
    Foo.list

    mock_redis_get Bar.service_key, 'bar.com'
    mock_request :get, 'bar.com/bar'
    Bar.list
  end

  describe 'rest requests' do
    before(:each) do
      mock_redis_get Person.service_key, service_url
    end

    describe '.list' do
      it 'should fetch all people' do
        mock_request :get, "#{service_url}/people", 'people_response.txt'
        people = Person.list
        expect(people).to all(be_a Person)
      end

      it 'allows custom params in the request' do
        mock_request :get, "#{service_url}/people?name=peter", 'people_response.txt'
        people = Person.list({:name => 'peter'})
        expect(people).to all(be_a Person)
      end
    end

    describe '.count' do
      it 'should get the count' do
        mock_request :get, "#{service_url}/people/count", 'count_response.txt'
        qtde = Person.count
        expect(qtde).to eq(3)
      end

      it 'allows custom params in the request' do
        mock_request :get, "#{service_url}/people/count?name=peter", 'count_response.txt'
        qtde = Person.count({:name => 'peter'})
        expect(qtde).to eq(3)
      end
    end

    describe '.find' do
      let(:person_id) { 3126880 }
      let(:expected_person) { Person.new(
          :id => 3126880,
          :name => 'Owens Bailey',
          :email => 'pacesoto@jamnation.com',
          :address => Address.new(:id => 9963426, :state => 'Connecticut', :city => 'Vincent', :street => 'Prince Street')
      ) }

      before(:each) do
        mock_request :get, "#{service_url}/people/#{person_id}", 'person_response.txt'
      end

      it 'should fetch the person with the specified id' do
        person = Person.find person_id
        expect(person).to be == expected_person
      end

      it 'get should be an alias to find' do
        person = Person.get person_id
        expect(person).to be == expected_person
      end
    end

    describe '#save' do
      let(:user_test) { build(:user) }

      before do
        user_params = user_test
        user_params.updated_at = ''
        user_params.created_at = ''
        user_params.id = ''
        body = {user_params.get_model_name => user_params.attributes}

        mock_request :post, "#{service_url}/user", 'new_person_response.txt', nil, body
      end

      it 'save the person and return the object with his id' do
        user_test.save!
        expect(user_test).to have_attributes(:id => 56)
      end
    end

    describe '#save with invalid parameters' do
      let(:user) { build(:user_with_invalid_password) }

      before do
        user_params = user
        user_params.updated_at = ''
        user_params.created_at = ''
        user_params.id = ''
        body = {user_params.get_model_name => user_params.attributes}

        mock_request :post, "#{service_url}/user", '400_response.txt', nil, body
      end

      it 'handle with errors' do
        user.save!
        expect(user).to have_attributes(:errors => ['Password is too short (minimum is 8 characters)'])
      end
    end

    describe '#update with invalid parameters' do
      let(:user) {
        user_instance = build(:user_with_invalid_password)
        user_instance.id = 123
        user_instance
      }

      before do
        body = {:user => {:id => '123', :created_at => '', :updated_at => '', :first_name => 'Test', :email => 'test@test.com',
                          :password => '123', :password_confirmation => '123'}}

        mock_request :put, "#{service_url}/user/123", '400_response.txt', nil, body
      end

      it 'handle with errors' do
        user.update!
        expect(user).to have_attributes(:errors => ['Password is too short (minimum is 8 characters)'])
      end
    end
  end
end
