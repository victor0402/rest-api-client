require 'spec_helper'
require_relative '../../support/some_domain'

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
end
