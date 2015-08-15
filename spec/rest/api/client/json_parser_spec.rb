require 'spec_helper'
require_relative '../../../support/fake_client/person'

describe RestApiClient do
  describe '.json_parser' do
    describe 'with a valid json' do

      context 'with an empty json response' do
        it 'should return an empty data' do
          json_content = '{"data": {}}'
          parsed_content = RestApiClient.parse_json json_content
          expect(parsed_content).to eq({'data' => {}})
        end

        it 'should return an empty list of data' do
          json_content = '{"data": []}'
          parsed_content = RestApiClient.parse_json json_content
          expect(parsed_content).to eq({'data' => []})
        end
      end

      context 'when the json contains a list of people' do
        it 'should parse the json and return the array of people' do
          json_content = expected_response 'people.json', true
          parsed_content = RestApiClient.parse_json json_content, {:type => Person}
          expect(parsed_content).to all(be_a Person)
        end
      end

      context 'when the json contains one object' do
        it 'should parse the json and return a Person' do
          json_content = expected_response 'person.json', true
          parsed_content = RestApiClient.parse_json json_content, {:type => Person}
          expect(parsed_content).to be_a Person
        end
      end

      describe 'with lazy associations' do
        before do
          @json_content = expected_response 'person_with_reference_association.json', true
          @parsed_content = RestApiClient.parse_json @json_content, {:type => Person}
        end

        it 'parses the json to a person' do
          expect(@parsed_content).to be_a Person
        end

        it 'parses the address_id to an address' do
          expect(@parsed_content.attributes).to include(:address)
          expect(@parsed_content.address.id).to eq 9963426
        end

        it 'dont associate the car_id to an object' do
          expect(@parsed_content.attributes).to include(:car_id)
          expect { @parsed_content.car }.to raise_error NoMethodError
          expect(@parsed_content.car_id).to eq 112233
        end
      end
    end

    describe 'with an invalid json' do
      it 'should return nil' do
        json_content = 'invalid content'
        parsed_content = RestApiClient.parse_json json_content
        expect(parsed_content).to be_nil
      end

      it 'should return the default return if it is in the options' do
        json_content = 'invalid content'
        parsed_content = RestApiClient.parse_json json_content, {:default_return => json_content}
        expect(parsed_content).to eq(json_content)
      end

    end
  end
end
