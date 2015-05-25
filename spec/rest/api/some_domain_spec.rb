require 'spec_helper'
require_relative '../../resources/some_domain'

describe RestApiClient do

  describe 'with a domain class' do
    context 'should have the REST instance methods' do
      subject(:instance_methods) { SomeDomain.instance_methods }

      it { expect(instance_methods).to include(:perform_get) }
      it { expect(instance_methods).to include(:perform_post) }
      it { expect(instance_methods).to include(:perform_delete) }
      it { expect(instance_methods).to include(:perform_put) }
      it { expect(instance_methods).to include(:save) }
      it { expect(instance_methods).to include(:delete) }
      it { expect(instance_methods).to include(:update) }
    end

    context 'should have the REST class methods' do
      subject(:class_methods) { SomeDomain.methods }

      it { expect(class_methods).to include(:list) }
    end
  end

  # describe "mocked query of web service" do
  #   it "should perform correct action on system data based on mocked response" do
  #     RestClient = double
  #     file = File.open('RELATIVE_FILE_PATH_HEREr') #Relative to root of Rails app
  #     data = file.read
  #     file.close
  #
  #     response = double
  #     response.stub(:code) { 200 }
  #     response.stub(:body) { data }
  #     response.stub(:headers) { {} }
  #     RestClient.stub(:get) { response }
  #
  #     YourApp.call_method_that_results_in_web_service_query
  #     #Your assertions here
  #
  #   end
  # end

end
