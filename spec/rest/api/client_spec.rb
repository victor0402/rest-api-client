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
    end

    describe '.count' do
      it 'should get the count' do
        mock_request :get, "#{service_url}/people/count", 'count_response.txt'
        qtde = Person.count
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
  end
end
