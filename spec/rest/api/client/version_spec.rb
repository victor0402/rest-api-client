require 'spec_helper'

describe RestApiClient do
  context '.version' do
    it 'has a version number' do
      expect(RestApiClient::VERSION).not_to be nil
    end
  end
end
