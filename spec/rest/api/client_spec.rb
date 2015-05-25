require 'spec_helper'
require 'spec/support/clients/foo_model_client'

describe RestApiClient do
  it 'allow different configurations' do
    FooModel.list
  end
end
